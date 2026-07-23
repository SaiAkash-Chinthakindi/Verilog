`timescale 1ns / 1ps

module pipo1(in,clk,rst,q);
  input [3:0]in;
  input clk,rst;
  output reg [3:0]q;
  
  always@(posedge clk)begin
    if(rst)
      q <= 4'd0;
      
    else
      q <= in;
  end
endmodule
