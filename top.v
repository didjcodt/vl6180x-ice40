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

module top(input clk, output D1, output D2, output D3, output D4, output D5);

reg        ready = 0;
reg [23:0] divider;
reg [3:0]  rot;

always @(posedge clk) begin
   if (ready) begin
      if (divider == 12000000) begin
         divider <= 0;
         rot <= {rot[2:0], rot[3]};
      end else begin
         divider <= divider + 1;
      end
   end else begin
      ready <= 1;
      rot <= 4'b0001;
      divider <= 0;
   end
end

assign D1 = rot[0];
assign D2 = rot[1];
assign D3 = rot[2];
assign D4 = rot[3];
assign D5 = rot[1] || rot[3];
endmodule // top
