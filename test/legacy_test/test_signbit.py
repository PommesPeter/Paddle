# Copyright (c) 2023 PaddlePaddle Authors. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import unittest

import numpy as np

import paddle


def np_signbit(x: np.ndarray):
    return np.signbit(x)


class TestSignbitAPI(unittest.TestCase):
    def setUp(self) -> None:
        self.support_dtypes = [
            'float16',
            'float32',
            'float64',
            'bfloat16',
            'int8',
            'int16',
            'int32',
            'int64',
        ]
        if paddle.device.get_device() == 'cpu':
            self.support_dtypes = [
                'float32',
                'float64',
                'int8',
                'int16',
                'int32',
                'int64',
            ]

    def test_dtype(self):
        for dtype in self.support_dtypes:
            x = paddle.to_tensor(
                np.random.randint(-10, 10, size=[12, 20, 2]).astype(dtype)
            )
            paddle.signbit(x)

    def test_float(self):
        for dtype in self.support_dtypes:
            np_x = np.random.randint(-10, 10, size=[12, 20, 2]).astype(dtype)
            x = paddle.to_tensor(np_x)
            out = paddle.signbit(x)
            np_out = out.numpy()
            out_expected = np_signbit(np_x)
            np.testing.assert_allclose(np_out, out_expected, rtol=1e-05)


if __name__ == "__main__":
    unittest.main()
