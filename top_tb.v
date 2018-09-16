`default_nettype none
// MIT License
//
// Copyright (c) 2018 Kaizen Wolf
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to
// deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.
`default_nettype none
`timescale 1ns/1ps

module testbench;

reg CLK = 0;
always #83.333333 CLK = ~CLK;

wire D1, D2, D3, D4, D5;

top dut (
   .CLK_12M(CLK),
   .D1(D1), .D2(D2), .D3(D3), .D4(D4), .D5(D5)
);

initial begin
   repeat (1_000_000) @(posedge CLK);
   $finish;
end

initial begin
   $dumpvars;
end

endmodule
