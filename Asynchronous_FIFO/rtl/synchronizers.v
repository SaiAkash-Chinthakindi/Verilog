`timescale 1ns / 1ps

module Synchronizers #(parameter width = 4)(clk,rst,data_in,data_out);
   input clk,rst;
   input [width-1:0]data_in;
   output [width-1:0]data_out;
   
   reg [width-1:0]sync1,sync2;
   
   assign data_out = sync2;
   
   always@(posedge clk or negedge rst)begin
     if(!rst)begin
       sync1 <= 0;
       sync2 <= 0;
     end
     else begin 
       sync1 <= data_in;
       sync2 <= sync1;
     end
   end
endmodule
