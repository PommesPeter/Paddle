
// Generated by generic_mixed_gemm_kernelLauncher.py - Do not edit.

#include "paddle/phi/kernels/fusion/cutlass/cutlass_kernels/fpA_intB_gemm/fpA_intB_gemm_template.h"

namespace phi {

template<>
void generic_mixed_gemm_kernelLauncher_template<half,
                                                uint8_t,
                                                cutlass::arch::Sm80,
                                                EpilogueOpBias,
                                                cutlass::gemm::GemmShape<16, 128, 64>,
                                                cutlass::gemm::GemmShape<16, 32, 64>,
                                                3>(
    const half* A,
    const uint8_t* B,
    const half* weight_scales,
    const half* biases,
    half* C,
    int m,
    int n,
    int k,
    CutlassGemmConfig gemm_config,
    char* workspace,
    size_t workspace_bytes,
    cudaStream_t stream,
    int* occupancy) {
    generic_mixed_gemm_kernelLauncher<half,
                                      uint8_t,
                                      cutlass::arch::Sm80,
                                      EpilogueOpBias,
                                      cutlass::gemm::GemmShape<16, 128, 64>,
                                      cutlass::gemm::GemmShape<16, 32, 64>,
                                      3>(
        A,
        B,
        weight_scales,
        biases,
        C,
        m,
        n,
        k,
        gemm_config,
        workspace,
        workspace_bytes,
        stream,
        occupancy);
}

template<>
void generic_mixed_gemm_kernelLauncher_template<half,
                                                uint8_t,
                                                cutlass::arch::Sm80,
                                                EpilogueOpBias,
                                                cutlass::gemm::GemmShape<32, 128, 64>,
                                                cutlass::gemm::GemmShape<32, 32, 64>,
                                                3>(
    const half* A,
    const uint8_t* B,
    const half* weight_scales,
    const half* biases,
    half* C,
    int m,
    int n,
    int k,
    CutlassGemmConfig gemm_config,
    char* workspace,
    size_t workspace_bytes,
    cudaStream_t stream,
    int* occupancy) {
    generic_mixed_gemm_kernelLauncher<half,
                                      uint8_t,
                                      cutlass::arch::Sm80,
                                      EpilogueOpBias,
                                      cutlass::gemm::GemmShape<32, 128, 64>,
                                      cutlass::gemm::GemmShape<32, 32, 64>,
                                      3>(
        A,
        B,
        weight_scales,
        biases,
        C,
        m,
        n,
        k,
        gemm_config,
        workspace,
        workspace_bytes,
        stream,
        occupancy);
}

template<>
void generic_mixed_gemm_kernelLauncher_template<half,
                                                uint8_t,
                                                cutlass::arch::Sm80,
                                                EpilogueOpBias,
                                                cutlass::gemm::GemmShape<64, 128, 64>,
                                                cutlass::gemm::GemmShape<64, 64, 64>,
                                                3>(
    const half* A,
    const uint8_t* B,
    const half* weight_scales,
    const half* biases,
    half* C,
    int m,
    int n,
    int k,
    CutlassGemmConfig gemm_config,
    char* workspace,
    size_t workspace_bytes,
    cudaStream_t stream,
    int* occupancy) {
    generic_mixed_gemm_kernelLauncher<half,
                                      uint8_t,
                                      cutlass::arch::Sm80,
                                      EpilogueOpBias,
                                      cutlass::gemm::GemmShape<64, 128, 64>,
                                      cutlass::gemm::GemmShape<64, 64, 64>,
                                      3>(
        A,
        B,
        weight_scales,
        biases,
        C,
        m,
        n,
        k,
        gemm_config,
        workspace,
        workspace_bytes,
        stream,
        occupancy);
}

template<>
void generic_mixed_gemm_kernelLauncher_template<half,
                                                uint8_t,
                                                cutlass::arch::Sm80,
                                                EpilogueOpBias,
                                                cutlass::gemm::GemmShape<128, 128, 64>,
                                                cutlass::gemm::GemmShape<64, 64, 64>,
                                                3>(
    const half* A,
    const uint8_t* B,
    const half* weight_scales,
    const half* biases,
    half* C,
    int m,
    int n,
    int k,
    CutlassGemmConfig gemm_config,
    char* workspace,
    size_t workspace_bytes,
    cudaStream_t stream,
    int* occupancy) {
    generic_mixed_gemm_kernelLauncher<half,
                                      uint8_t,
                                      cutlass::arch::Sm80,
                                      EpilogueOpBias,
                                      cutlass::gemm::GemmShape<128, 128, 64>,
                                      cutlass::gemm::GemmShape<64, 64, 64>,
                                      3>(
        A,
        B,
        weight_scales,
        biases,
        C,
        m,
        n,
        k,
        gemm_config,
        workspace,
        workspace_bytes,
        stream,
        occupancy);
}

template<>
void generic_mixed_gemm_kernelLauncher_template<half,
                                                uint8_t,
                                                cutlass::arch::Sm80,
                                                EpilogueOpBias,
                                                cutlass::gemm::GemmShape<128, 256, 64>,
                                                cutlass::gemm::GemmShape<64, 64, 64>,
                                                3>(
    const half* A,
    const uint8_t* B,
    const half* weight_scales,
    const half* biases,
    half* C,
    int m,
    int n,
    int k,
    CutlassGemmConfig gemm_config,
    char* workspace,
    size_t workspace_bytes,
    cudaStream_t stream,
    int* occupancy) {
    generic_mixed_gemm_kernelLauncher<half,
                                      uint8_t,
                                      cutlass::arch::Sm80,
                                      EpilogueOpBias,
                                      cutlass::gemm::GemmShape<128, 256, 64>,
                                      cutlass::gemm::GemmShape<64, 64, 64>,
                                      3>(
        A,
        B,
        weight_scales,
        biases,
        C,
        m,
        n,
        k,
        gemm_config,
        workspace,
        workspace_bytes,
        stream,
        occupancy);
}

template<>
void generic_mixed_gemm_kernelLauncher_template<half,
                                                cutlass::uint4b_t,
                                                cutlass::arch::Sm80,
                                                EpilogueOpBias,
                                                cutlass::gemm::GemmShape<16, 128, 64>,
                                                cutlass::gemm::GemmShape<16, 32, 64>,
                                                3>(
    const half* A,
    const cutlass::uint4b_t* B,
    const half* weight_scales,
    const half* biases,
    half* C,
    int m,
    int n,
    int k,
    CutlassGemmConfig gemm_config,
    char* workspace,
    size_t workspace_bytes,
    cudaStream_t stream,
    int* occupancy) {
    generic_mixed_gemm_kernelLauncher<half,
                                      cutlass::uint4b_t,
                                      cutlass::arch::Sm80,
                                      EpilogueOpBias,
                                      cutlass::gemm::GemmShape<16, 128, 64>,
                                      cutlass::gemm::GemmShape<16, 32, 64>,
                                      3>(
        A,
        B,
        weight_scales,
        biases,
        C,
        m,
        n,
        k,
        gemm_config,
        workspace,
        workspace_bytes,
        stream,
        occupancy);
}

template<>
void generic_mixed_gemm_kernelLauncher_template<half,
                                                cutlass::uint4b_t,
                                                cutlass::arch::Sm80,
                                                EpilogueOpBias,
                                                cutlass::gemm::GemmShape<32, 128, 64>,
                                                cutlass::gemm::GemmShape<32, 32, 64>,
                                                3>(
    const half* A,
    const cutlass::uint4b_t* B,
    const half* weight_scales,
    const half* biases,
    half* C,
    int m,
    int n,
    int k,
    CutlassGemmConfig gemm_config,
    char* workspace,
    size_t workspace_bytes,
    cudaStream_t stream,
    int* occupancy) {
    generic_mixed_gemm_kernelLauncher<half,
                                      cutlass::uint4b_t,
                                      cutlass::arch::Sm80,
                                      EpilogueOpBias,
                                      cutlass::gemm::GemmShape<32, 128, 64>,
                                      cutlass::gemm::GemmShape<32, 32, 64>,
                                      3>(
        A,
        B,
        weight_scales,
        biases,
        C,
        m,
        n,
        k,
        gemm_config,
        workspace,
        workspace_bytes,
        stream,
        occupancy);
}

template<>
void generic_mixed_gemm_kernelLauncher_template<half,
                                                cutlass::uint4b_t,
                                                cutlass::arch::Sm80,
                                                EpilogueOpBias,
                                                cutlass::gemm::GemmShape<64, 128, 64>,
                                                cutlass::gemm::GemmShape<64, 64, 64>,
                                                3>(
    const half* A,
    const cutlass::uint4b_t* B,
    const half* weight_scales,
    const half* biases,
    half* C,
    int m,
    int n,
    int k,
    CutlassGemmConfig gemm_config,
    char* workspace,
    size_t workspace_bytes,
    cudaStream_t stream,
    int* occupancy) {
    generic_mixed_gemm_kernelLauncher<half,
                                      cutlass::uint4b_t,
                                      cutlass::arch::Sm80,
                                      EpilogueOpBias,
                                      cutlass::gemm::GemmShape<64, 128, 64>,
                                      cutlass::gemm::GemmShape<64, 64, 64>,
                                      3>(
        A,
        B,
        weight_scales,
        biases,
        C,
        m,
        n,
        k,
        gemm_config,
        workspace,
        workspace_bytes,
        stream,
        occupancy);
}

template<>
void generic_mixed_gemm_kernelLauncher_template<half,
                                                cutlass::uint4b_t,
                                                cutlass::arch::Sm80,
                                                EpilogueOpBias,
                                                cutlass::gemm::GemmShape<128, 128, 64>,
                                                cutlass::gemm::GemmShape<64, 64, 64>,
                                                3>(
    const half* A,
    const cutlass::uint4b_t* B,
    const half* weight_scales,
    const half* biases,
    half* C,
    int m,
    int n,
    int k,
    CutlassGemmConfig gemm_config,
    char* workspace,
    size_t workspace_bytes,
    cudaStream_t stream,
    int* occupancy) {
    generic_mixed_gemm_kernelLauncher<half,
                                      cutlass::uint4b_t,
                                      cutlass::arch::Sm80,
                                      EpilogueOpBias,
                                      cutlass::gemm::GemmShape<128, 128, 64>,
                                      cutlass::gemm::GemmShape<64, 64, 64>,
                                      3>(
        A,
        B,
        weight_scales,
        biases,
        C,
        m,
        n,
        k,
        gemm_config,
        workspace,
        workspace_bytes,
        stream,
        occupancy);
}

template<>
void generic_mixed_gemm_kernelLauncher_template<half,
                                                cutlass::uint4b_t,
                                                cutlass::arch::Sm80,
                                                EpilogueOpBias,
                                                cutlass::gemm::GemmShape<128, 256, 64>,
                                                cutlass::gemm::GemmShape<64, 64, 64>,
                                                3>(
    const half* A,
    const cutlass::uint4b_t* B,
    const half* weight_scales,
    const half* biases,
    half* C,
    int m,
    int n,
    int k,
    CutlassGemmConfig gemm_config,
    char* workspace,
    size_t workspace_bytes,
    cudaStream_t stream,
    int* occupancy) {
    generic_mixed_gemm_kernelLauncher<half,
                                      cutlass::uint4b_t,
                                      cutlass::arch::Sm80,
                                      EpilogueOpBias,
                                      cutlass::gemm::GemmShape<128, 256, 64>,
                                      cutlass::gemm::GemmShape<64, 64, 64>,
                                      3>(
        A,
        B,
        weight_scales,
        biases,
        C,
        m,
        n,
        k,
        gemm_config,
        workspace,
        workspace_bytes,
        stream,
        occupancy);
}

} // namespace phi

