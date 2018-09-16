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

module led #(parameter COUNTER=10) (
   input  CLK,
   input  NRST,
   output D1,
   output D2,
   output D3,
   output D4,
   output D5
);

reg [$clog2(COUNTER)+1:0] counter;
reg [3:0]  rot;

always @(posedge CLK)
   if (~NRST) begin
      counter <= 0;
      rot <= 4'b0101;
   end else begin
      if (counter == COUNTER) begin
         counter <= 0;
         rot <= {rot[2:0], rot[3]};
      end else begin
         counter <= counter + 1'b1;
      end
   end

assign D1 = rot[0];
assign D2 = rot[1];
assign D3 = rot[2];
assign D4 = rot[3];
assign D5 = 1;

endmodule // led
