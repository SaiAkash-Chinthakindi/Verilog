`timescale 1ns / 1ps


module siso_1(clk,rst,in,q);
  input clk,rst,in;
  output  q;
  reg [3:0]d;
  
  always@(posedge clk or posedge rst)begin
    if(rst)
      d <= 0;
      
    else
      d <= {in,d[3:1]};
      //q <= d[0];
  end
  
   assign q = d[0];
  
endmodule
