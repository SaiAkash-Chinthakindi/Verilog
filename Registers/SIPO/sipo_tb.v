`timescale 1ns / 1ps

module sipo_tb ;
  reg in,clk,rst;
  wire [3:0]q;
  
  sipo1 m1(.in(in),.clk(clk),.rst(rst),.q(q));
  
  initial begin
   rst = 1'b0;
   clk = 1'b0;
  end
  
  always #5 clk = ~clk;
  
  initial begin
  #4 rst = 1'b1;
  #3 rst = 1'b0;
  end
  
  initial begin
    #14 in = 1'b1;
    #10 in = 1'b1;
    #10 in = 1'b0;
    #10 in = 1'b1;
  end
  
  initial #60 $finish;
endmodule
