`timescale 1ns / 1ps

module sipo1(in,clk,rst,q);
  input in,clk,rst;
  output reg [3:0]q;
  
  //reg [3:0]d;
  
  always@(posedge clk)begin
    if(rst)
      q <= 4'b0;
    else
      q <= {in,q[3:1]};
  end
endmodule
