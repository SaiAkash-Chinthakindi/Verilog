`timescale 1ns / 1ps

module Synchronous_FIFO #(parameter width = 8,depth = 8)(clk,rst,wr_enable,rd_enable,full,empty,data_in,data_out,count1);
   input clk,rst;
   input [width-1:0]data_in;
   input wr_enable,rd_enable;
   output full,empty;
   output reg [width-1:0]data_out;
   output [$clog2(depth+1)-1:0]count1;
   
   reg [width-1:0]mem[depth-1:0];
   reg [$clog2(depth)-1:0]wr_ptr,rd_ptr;
   reg [$clog2(depth+1)-1:0]count;
   
   assign full = (count == depth)? 1'b1 : 1'b0;
   assign empty = (count == 0)? 1'b1 : 1'b0;
   assign count1 = count;
   
   // write block
   always@(posedge clk or negedge rst)begin
     if(!rst)begin
        wr_ptr <= 0;
     end
     else begin
       if(wr_enable && !full)begin
           mem[wr_ptr] <= data_in;
           //wr_ptr = wr_ptr + 1'b1;
           
           if(wr_ptr == depth-1'b1)begin
              wr_ptr <= 0;
           end
           else
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
         
         if(rd_ptr == depth-1'b1)begin
            rd_ptr <= 0;
         end
         else
            rd_ptr <= rd_ptr + 1'b1;
       end
     end
   end
   
   //count block
   always@(posedge clk or negedge rst)begin
     if(!rst)begin
        count <= 0;
     end
     else begin
        case({wr_enable && !full,rd_enable && !empty})
           2'b10 : count <= count + 1'b1;
           2'b01 : count <= count - 1'b1;
           default : count <= count;
        endcase
     end
   end
endmodule
