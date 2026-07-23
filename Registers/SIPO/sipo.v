`timescale 1ns / 1ps

module sipo(in,clk,rst,q);
  input in,clk,rst;
  output [3:0]q;
  
  d_ff m1(.d(in),.clk(clk),.rst(rst),.q(q[3]));
  d_ff m2(.d(q[3]),.clk(clk),.rst(rst),.q(q[2]));
  d_ff m3(.d(q[2]),.clk(clk),.rst(rst),.q(q[1]));
  d_ff m4(.d(q[1]),.clk(clk),.rst(rst),.q(q[0]));
  
endmodule
