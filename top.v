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

module top (
   // System clock
   input CLK_12M,
   // LEDs
   output D1, output D2, output D3, output D4, output D5
);

// Generate a reset-like signal on startup
reg ready = 0;
always @(posedge CLK_12M)
   if (~ready) begin
      ready <= 1;
   end

// LED animation
wire [31:0] breath_out;
breath breath_module (
   .CLK(CLK_12M),
   .NRST(ready),
   .PERIOD(12_000_000),
   .WAIT_PERIOD(10_000),
   .OUT(breath_out)
);

wire pwm_out;
pwm pwm_sig (
   .CLK(CLK_12M),
   .NRST(ready),
   .COUNTER(1024),
   .PERIOD(breath_out),
   .PWM_OUT(pwm_out)
);

wire d1_count, d2_count, d3_count, d4_count, d5_count;
led #(.COUNTER(1_000_000)) led_module (
   .CLK(CLK_12M),
   .NRST(ready),
   .D1(d1_count), .D2(d2_count), .D3(d3_count), .D4(d4_count), .D5(d5_count)
);

assign D1 = d1_count & pwm_out;
assign D2 = d2_count & pwm_out;
assign D3 = d3_count & pwm_out;
assign D4 = d4_count & pwm_out;
assign D5 = d5_count & pwm_out;

endmodule // top
