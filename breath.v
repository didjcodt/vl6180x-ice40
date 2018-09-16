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

module breath (
   input         CLK,
   input         NRST,
   input  [31:0] PERIOD,
   input  [31:0] WAIT_PERIOD,
   output [31:0] OUT
);

reg [31:0] counter;
always @(posedge CLK)
   if (~NRST) begin
      counter <= 0;
   end else begin
      if (counter == PERIOD) begin
         counter <= 0;
      end else begin
         counter <= counter + 1'b1;
      end
   end

reg breath_up;
always @(posedge CLK)
   if (~NRST) begin
      breath_up <= 1;
   end else begin
      if (counter == PERIOD) begin
         breath_up <= ~breath_up;
      end
   end

reg [31:0] wait_counter;
always @(posedge CLK)
   if (~NRST) begin
      wait_counter <= 0;
   end else begin
      if (wait_counter == WAIT_PERIOD) begin
         wait_counter <= 0;
      end else begin
         wait_counter <= wait_counter + 1'b1;
      end
   end

reg [31:0] out_reg;
always @(posedge CLK)
   if (~NRST) begin
      out_reg <= 0;
   end else begin
      if (wait_counter == WAIT_PERIOD) begin
         if (breath_up) begin
            out_reg <= out_reg + 1;
         end else begin
            out_reg <= out_reg - 1;
         end
      end
   end

assign OUT = out_reg;

endmodule // breath
