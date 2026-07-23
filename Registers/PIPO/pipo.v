`timescale 1ns / 1ps


module pipo(in,clk,rst,q);
  input [3:0]in;
  input clk,rst;
  output [3:0]q;
  
  d_ff m1(.in(in[3]),.clk(clk),.rst(rst),.q(q[3]));
  d_ff m2(.in(in[2]),.clk(clk),.rst(rst),.q(q[2]));
  d_ff m3(.in(in[1]),.clk(clk),.rst(rst),.q(q[1]));
  d_ff m4(.in(in[0]),.clk(clk),.rst(rst),.q(q[0]));
  
endmodule
