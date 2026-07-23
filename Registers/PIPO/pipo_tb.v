`timescale 1ns / 1ps


module pipo_tb ;
  reg [3:0]in;
  reg clk,rst;
  wire [3:0]q;
  
  //pipo m1(.in(in),.clk(clk),.rst(rst),.q(q));
  pipo1 m1(.in(in),.clk(clk),.rst(rst),.q(q));
  initial begin
    clk = 1'b0;
    rst = 1'b0;
    #4 rst = 1'b1;
    #3 rst = 1'b0;
  end
  
  always #5 clk = ~clk;
  
  initial begin
    #14 in = 4'ha;
    #10 in = 4'hd;
    #10 in = 4'h9;
    #10 in = 4'h2;
  end
  
  initial #60 $finish;
endmodule
