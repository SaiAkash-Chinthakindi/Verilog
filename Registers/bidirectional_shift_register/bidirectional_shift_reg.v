`timescale 1ns / 1ps

/*
module bidirectional_shift_reg #(parameter N = 4)(clk,rst,data_in,shift_op,data_out);
   input clk;
   input rst;
   input data_in;
   input shift_op;
   output [N-1:0]data_out;
   
   wire w1,w2,w3,w4;
   assign data_out = {w1,w2,w3,w4};
   
   sub_module m1(.clk(clk),.rst(rst),.data({w2,data_in}),.shift(shift_op),.q(w1));
   sub_module m2(.clk(clk),.rst(rst),.data({w3,w1}),.shift(shift_op),.q(w2));
   sub_module m3(.clk(clk),.rst(rst),.data({w4,w2}),.shift(shift_op),.q(w3));
   sub_module m4(.clk(clk),.rst(rst),.data({data_in,w3}),.shift(shift_op),.q(w4));
   
endmodule

*/

module bidirectional_shift_reg #(parameter N = 4)(clk,rst,data_in,shift_op,data_out);
   input clk;
   input rst;
   input data_in;
   input shift_op; // shift_op == 0 : it will right shift the bits, 1 it will shift the bits to left
   output [N-1:0]data_out;
   
   wire [N-1:0]w;
   assign data_out = w;
   
   genvar i;
   generate
     for(i = 0; i < N; i = i + 1'b1) begin
        wire left_in,right_in;
        
        assign left_in = (i == 0)? data_in : w[i - 1];
        assign right_in = (i == N-1'b1)? data_in : w[i + 1];
        
        sub_module m1(.clk(clk),.rst(rst),.data({left_in,right_in}),.shift(shift_op),.q(w[i]));
     end
   endgenerate
endmodule

module sub_module(clk,rst,data,shift,q);
   input clk;
   input rst;
   input [1:0]data;
   input shift;
   output reg q;
   
   always@(posedge clk or negedge rst)begin
     if(!rst) 
        q <= 0;
     else begin
       case(shift)
         1'b0 : q <= data[0];
         1'b1 : q <= data[1];
         default: q <= q;
       endcase
     end
   end
endmodule

