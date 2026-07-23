`timescale 1ns / 1ps

module SISO(clk,rst,in,q);
  input in,clk,rst;
  output q;
  wire w1,w2,w3;
  
  d_ff m1(.clk(clk),.rst(rst),.d(in),.q(w1));
  d_ff m2(.clk(clk),.rst(rst),.d(w1),.q(w2));
  d_ff m3(.clk(clk),.rst(rst),.d(w2),.q(w3));
  d_ff m4(.clk(clk),.rst(rst),.d(w3),.q(q));
  
endmodule
