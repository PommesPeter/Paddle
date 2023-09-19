// Copyright (c) 2023 PaddlePaddle Authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#include "paddle/fluid/pir/transforms/constant_folding_pass.h"

#include <memory>
#include <string>
#include <unordered_map>

// NOTE(zhangbo9674): File pd_op.h is generated by op_gen.py, see details in
// paddle/fluid/pir/dialect/CMakeLists.txt.
#include "paddle/fluid/pir/dialect/operator/ir/pd_op.h"

#include "paddle/fluid/framework/new_executor/interpretercore.h"
#include "paddle/fluid/framework/scope.h"
#include "paddle/fluid/pir/dialect/operator/ir/op_dialect.h"
#include "paddle/fluid/pir/dialect/operator/ir/op_type.h"
#include "paddle/fluid/pir/transforms/pd_op_to_kernel_pass.h"
#include "paddle/fluid/pir/transforms/transform_general_functions.h"
#include "paddle/phi/common/place.h"
#include "paddle/phi/core/dense_tensor.h"
#include "paddle/phi/core/enforce.h"
#include "paddle/pir/core/builtin_op.h"
#include "paddle/pir/core/ir_context.h"
#include "paddle/pir/core/operation.h"
#include "paddle/pir/core/parameter.h"
#include "paddle/pir/core/program.h"
#include "paddle/pir/pass/pass.h"
#include "paddle/pir/pattern_rewrite/frozen_rewrite_pattern_set.h"
#include "paddle/pir/pattern_rewrite/pattern_match.h"
#include "paddle/pir/pattern_rewrite/pattern_rewrite_driver.h"

namespace {

class ConstantFoldingPattern : public pir::RewritePattern {
 public:
  ConstantFoldingPattern(pir::IrContext* context,
                         pir::PatternBenefit benefit = 1,
                         const std::vector<std::string>& generated_names = {})
      : RewritePattern(MatchAnyOpTypeTag(), benefit, context, generated_names) {
  }

  bool Match(pir::Operation* op) const override {
    // TODO(liuyuanle): Use trait to improve robustness.
    if (op->dyn_cast<pir::GetParameterOp>() ||
        op->dyn_cast<pir::SetParameterOp>() ||
        op->dyn_cast<paddle::dialect::FetchOp>())
      return false;

    // Inputs must come from get parameter op.
    for (uint32_t i = 0; i < op->num_operands(); ++i)
      if (pir::GetDefiningOpForInput(op, i)->dyn_cast<pir::GetParameterOp>() ==
          nullptr)
        return false;
    return true;
  }

  void Rewrite(pir::Operation* op,
               pir::PatternRewriter& rewriter) const override {  // NOLINT
    pir::Program* program = op->GetParentProgram();
    auto temp_program = BuildProgramFromOperation(op);

    std::vector<std::string> fetch_var_names;
    auto block = temp_program->block();
    for (auto it = block->begin(); it != block->end(); ++it) {
      if ((*it)->isa<paddle::dialect::FetchOp>()) {
        size_t index = (*it)
                           ->attributes()
                           .at("col")
                           .dyn_cast<pir::Int32Attribute>()
                           .data();

        if (fetch_var_names.size() < index + 1) {
          fetch_var_names.resize(index + 1);
        }

        fetch_var_names[index] = (*it)
                                     ->attributes()
                                     .at("name")
                                     .dyn_cast<pir::StrAttribute>()
                                     .AsString() +
                                 "@fetch";
      }
    }

    // Execute program
    exe_config_.create_local_scope = false;
    auto kernel_program =
        paddle::dialect::PdOpLowerToKernelPass(temp_program.get());
    paddle::framework::InterpreterCore core(phi::CPUPlace{},
                                            fetch_var_names,
                                            kernel_program->block(),
                                            &scope_,
                                            exe_config_);

    paddle::framework::FetchList fetch_list = core.Run({});

    // TODO(liuyuanle): Support multiple output.
    auto out_tensor = PADDLE_GET_CONST(phi::DenseTensor, fetch_list[0]);
    std::unique_ptr<pir::Parameter> parameter =
        std::make_unique<pir::Parameter>(
            reinterpret_cast<void*>(out_tensor.data()),
            out_tensor.numel() * phi::SizeOf(out_tensor.dtype()),
            op->result(0).type());

    std::string param_name =
        "@constant_folding_pass@_" + std::to_string(suffix_++);
    exe_config_.skip_gc_vars.insert(param_name);

    auto* param_var = scope_.Var(param_name);
    auto* param_tensor = param_var->GetMutable<phi::DenseTensor>();
    *param_tensor = out_tensor;
    program->SetParameter(param_name, std::move(parameter));
    // rewriter.SetInsertionPoint(op);
    auto get_parameter_op =
        rewriter.Build<pir::GetParameterOp>(param_name, op->result(0).type());

    rewriter.ReplaceAllUsesWith(op->result(0), get_parameter_op->result(0));
    rewriter.EraseOp(op);
  }

 private:
  std::unique_ptr<pir::Program> BuildProgramFromOperation(
      pir::Operation* op) const {
    auto program = std::make_unique<pir::Program>(ir_context());
    pir::Builder builder = pir::Builder(ir_context(), program->block());

    // prepare op inputs
    std::vector<pir::Value> op_inputs;
    for (uint32_t i = 0; i < op->num_operands(); i++) {
      PADDLE_ENFORCE_EQ(
          op->operand_source(i).type().isa<paddle::dialect::DenseTensorType>(),
          true,
          phi::errors::InvalidArgument(
              "Op's input must be a dense tensor type."));

      auto [param_name, param] =
          pir::GetParameterFromValue(op->operand_source(i));
      program->SetParameter(param_name,
                            std::make_unique<pir::Parameter>(*param));

      auto* param_var = scope_.FindVar(param_name);
      PADDLE_ENFORCE_NOT_NULL(
          param_var,
          phi::errors::InvalidArgument("Parameter var not in scope."));

      auto get_parameter_op = builder.Build<pir::GetParameterOp>(
          param_name, op->operand_source(i).type());
      op_inputs.push_back(get_parameter_op->result(0));
    }

    // prepare op outputs
    std::vector<pir::Type> output_types;
    for (uint32_t i = 0; i < op->num_results(); i++) {
      output_types.push_back(op->result(i).type());
    }

    auto* temp_op =
        builder.Build(op_inputs, op->attributes(), output_types, op->info());

    // TODO(liuyuanle): Support multiple output.
    // for (uint32_t i = 0; i < op->num_results(); i++) {
    PADDLE_ENFORCE_EQ(
        temp_op->result(0).type().isa<paddle::dialect::DenseTensorType>(),
        true,
        phi::errors::InvalidArgument(
            "Op's output must be a dense tensor type."));

    builder.Build<paddle::dialect::FetchOp>(
        temp_op->result(0), "fetch_" + std::to_string(suffix_++), 0);
    // }

    return program;
  }

 private:
  inline static size_t suffix_{0};
  inline static paddle::framework::Scope scope_{};
  inline static paddle::framework::interpreter::ExecutionConfig exe_config_{};
};

class ConstantFoldingPass : public pir::Pass {
 public:
  // TODO(liuyuanle): Naming convention for pass.
  ConstantFoldingPass() : pir::Pass("ConstantFoldingPass", 1) {}

  bool Initialize(pir::IrContext* context) override {
    pir::RewritePatternSet ps(context);
    ps.Add<ConstantFoldingPattern>(context);
    patterns_ = pir::FrozenRewritePatternSet(std::move(ps));
    return true;
  }

  void Run(pir::Operation* op) override {
    pir::GreedyRewriteConfig cfg;
    cfg.use_top_down_traversal = true;
    cfg.max_iterations = 10;
    pir::ApplyPatternsGreedily(op->region(0), patterns_, cfg);
  }

  bool CanApplyOn(pir::Operation* op) const override {
    return op->isa<::pir::ModuleOp>() && op->num_regions() > 0;
  }

 private:
  pir::FrozenRewritePatternSet patterns_;
};

}  // namespace

namespace pir {

std::unique_ptr<Pass> CreateConstantFoldingPass() {
  return std::make_unique<ConstantFoldingPass>();
}

}  // namespace pir
