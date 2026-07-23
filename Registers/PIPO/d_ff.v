`timescale 1ns / 1ps


module d_ff(in,clk,rst,q);
  input in,clk,rst;
  output reg q ;
  
  always@(posedge clk)begin
    if(rst)
      q <= 1'b0;
    else 
      q <= in;
  end
endmodule
