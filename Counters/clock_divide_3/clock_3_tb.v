`timescale 1ns / 1ps

module clock_3_tb();
   reg clk;
   reg rst;
   wire clk_out;
   wire clk_out1;
   wire clk_out2;
   
   clock_3 m1(.clk(clk),.rst(rst),.clk_out(clk_out),.clk_out1(clk_out1),.clk_out2(clk_out2));
   
   initial begin 
     clk = 0;
     rst = 1;
     @(negedge clk) rst = 1'b0;
     @(negedge clk);
     @(negedge clk) rst = 1'b1;
     
     #100 $finish;
   end
   
   always #5 clk = ~clk;
endmodule
