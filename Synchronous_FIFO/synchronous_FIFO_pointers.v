`timescale 1ns / 1ps

module Synchronous_FIFO_pointers #(parameter width = 8,depth = 8)(clk,rst,wr_enable,rd_enable,full,empty,data_in,data_out);
   input clk,rst;
   input [width-1:0]data_in;
   input wr_enable,rd_enable;
   output full,empty;
   output reg [width-1:0]data_out;

   
   reg [width-1:0]mem[depth-1:0];
   reg [$clog2(depth):0]wr_ptr,rd_ptr;
   reg [$clog2(depth+1)-1:0]count;
   
   assign full = (wr_ptr[$clog2(depth)-1:0] == rd_ptr[$clog2(depth)-1:0]) && (wr_ptr[$clog2(depth)] != rd_ptr[$clog2(depth)]);
   assign empty = (wr_ptr == rd_ptr);

   
   // write block
   always@(posedge clk or negedge rst)begin
     if(!rst)begin
        wr_ptr <= 0;
     end
     else begin
       if(wr_enable && !full)begin
           mem[wr_ptr] <= data_in;
           wr_ptr <= wr_ptr + 1'b1;
       end
     end
   end
   
   //read block
   always@(posedge clk or negedge rst)begin
     if(!rst)begin
       rd_ptr <= 0;
     end
     else begin
       if(rd_enable && !empty)begin
         data_out <= mem[rd_ptr];
         rd_ptr <= rd_ptr + 1'b1;
       end
     end
   end
 
endmodule
