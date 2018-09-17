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

module i2c_master #(parameter CLK_DIVIDER=1) (
   input CLK,
   input NRST,
   // I²C output
   // Expressed in tri-state inout logic:
   // _I = input
   // _O = output
   // _E = output enable
   input  SDA_I,
   output SDA_O,
   output SDA_E,
   input  SCL_I,
   output SCL_O,
   output SCL_E
);

reg sda;
always @(posedge CLK)
   if (~NRST) begin
      sda <= 0;
   end

reg scl;
always @(posedge CLK)
   if (~NRST) begin
      scl <= 0;
   end

// Internal logic is expressed push-pull like, transform to open drain inouts
// TODO
assign SDA_O = sda ? 1'b1 : 0;
assign SDA_E = sda ? 1'b1 : 0;
assign SCL_O = scl ? 1'b1 : 0;
assign SCL_E = scl ? 1'b1 : 0;

endmodule // top
