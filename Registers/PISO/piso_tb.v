`timescale 1ns / 1ps


module piso_tb ;
  reg [3:0]in;
  reg clk,rst,load;
  wire q;
  
 // piso m1(.in(in),.load(load),.clk(clk),.rst(rst),.q(q));
  piso1 m1(.in(in),.load(load),.clk(clk),.rst(rst),.q(q));
  
  initial begin
    clk = 1'b0;
    rst = 1'b0;
    load = 1'b0;
    #4 rst = 1'b1;
    #3 rst = 1'b0;
    #6 load = 1'b1;
    #3 load = 1'b0;
  end
  
  always #5 clk = ~clk;
  
  initial begin
    #11 in = 4'b1110;
  end
  initial #60 $finish;
endmodule
