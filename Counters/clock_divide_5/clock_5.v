`timescale 1ns / 1ps


module clock_5(clk,rst,clk_out,clk_out1);
   input clk;
   input rst;
   output clk_out; // the output is high with the 50% duty cycle time. 
   output clk_out1; // the output will be high only for one clock cycle. it is not 50% duty cycle
   
   reg [2:0]count;
   reg count_neg;
   
   assign clk_out = (count[1] | count_neg);
   assign clk_out1 = count[2];
   
   always@(negedge clk or negedge rst)begin
     if(!rst)
       count_neg <= 1'b0;
     else
       count_neg <= count[1];
     
   end
   always@(posedge clk or negedge rst)begin
     if(!rst) 
       count <= 0;
     else begin
       if(count == 4)
          count <= 0;
       else
          count <= count + 1'b1;
     end
   end
endmodule
