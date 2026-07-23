`timescale 1ns / 1ps

module siso_tb ;
  reg in,clk,rst;
  wire q;
  
  siso_1 m1 (.clk(clk),.rst(rst),.in(in),.q(q));
  
  initial begin
     $monitor($time,"   q = %d",q);
    clk = 1'b0;
    rst = 1'b0;
    #4 rst = 1'b1;
    #3 rst = 1'b0;
  end
  
  always #5 clk = ~clk;
  
  initial begin
    #14 in = 1'b1;
    #10 in = 1'b0;
    #10 in = 1'b1;
    #10 in = 1'b0;
    #10 in = 1'b0;
    #10 in = 1'b0;
  end
  
  initial #120 $finish;
endmodule
