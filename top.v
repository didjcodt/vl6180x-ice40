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
   output D1, output D2, output D3, output D4, output D5,
   // PMOD connector
   input PMOD1, input PMOD2, input PMOD7, input PMOD8
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

// I²C master
// Arachne-pne currently does not support inferring tri-state IO, so manually
// infer a SB_IO block
// The internal pullup is enabled. This parameter is used only on bank 0, 1 and 2.
// See http://www.latticesemi.com/~/media/LatticeSemi/Documents/TechnicalBriefs/SBTICETechnologyLibrary201504.pdf
wire sda_i, sda_o, sda_e;
wire scl_i, scl_o, scl_e;
i2c_master #(.CLK_DIVIDER(1)) vl6180_master (
   .CLK(CLK_12M),
   .NRST(ready),
   .SDA_I(sda_i), .SDA_O(sda_o), .SDA_E(sda_e),
   .SCL_I(scl_i), .SCL_O(scl_o), .SCL_E(scl_e)
);

SB_IO #(.PIN_TYPE(6'b1010_01), .PULLUP(1'b1)) sda (
   .PACKAGE_PIN(PMOD7),
   .OUTPUT_ENABLE(sda_e),
   .D_OUT_0(sda_o),
   .D_IN_0(sda_i)
);

SB_IO #(.PIN_TYPE(6'b1010_01), .PULLUP(1'b1)) scl (
   .PACKAGE_PIN(PMOD8),
   .OUTPUT_ENABLE(scl_e),
   .D_OUT_0(scl_o),
   .D_IN_0(scl_i)
);

endmodule // top
