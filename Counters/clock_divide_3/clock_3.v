`timescale 1ns / 1ps

// the code is about producing a divide/3 with 33% duty cycle and 50% duty cycle;

module clock_3(clk,rst,clk_out,clk_out1,clk_out2);
   input clk;
   input rst;
   output clk_out1; // 33% duty cycle output
   output clk_out2;
   output clk_out;  // 50% duty cycle output
   
   reg [1:0]count;
   reg count_neg;
   assign clk_out1 = count[1];
   assign clk_out2 = count_neg;
   assign clk_out = count[1]| count_neg;
   
   always@(negedge clk or negedge rst)begin
     if(!rst)
       count_neg <= 0;
     else
       count_neg <= count[1];
   end
   always@(posedge clk or negedge rst)begin
     if(!rst)begin
       count <= 0;
     end
     else begin
       if(count == 2)
         count <= 0;
       else
         count <= count + 1'b1;
     end
   end
endmodule
