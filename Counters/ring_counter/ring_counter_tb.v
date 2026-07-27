`timescale 1ns / 1ps

module ring_counter_tb();
   reg clk,preset;
   wire [3:0]q;
   
   ring_counter m1(.clk(clk),.preset(preset),.q(q));
   
   initial begin
     $monitor ("time = %0d,preset = %b, q = %b",$time,preset,q);
     preset = 1'b1;
     clk = 1'b0;
     //preset <= #4 1'b0;
     //preset <= #7 1'b1;
   end
   
   always #5 clk = ~clk;
   
   initial begin
     #4 preset =  1'b0;
     #3 preset =  1'b1;
   end 
  
   initial #50 $finish;
endmodule
