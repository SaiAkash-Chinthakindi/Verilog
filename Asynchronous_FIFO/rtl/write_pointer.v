`timescale 1ns / 1ps

module write_pointer #(parameter width = 4)(w_clk,w_rst,w_en,w_bin_ptr,w_gray_ptr,r_gray_ptr_sync,full);
   input w_clk,w_rst;
   input w_en;
   input [width-1:0]r_gray_ptr_sync;
   output reg[width-1:0]w_bin_ptr;
   output reg[width-1:0]w_gray_ptr;
   output reg full;
   
   wire [width-1:0]w_bin_ptr_nxt;
   wire [width-1:0]w_gray_ptr_nxt;
   wire full_next;
   
   assign w_bin_ptr_nxt = (w_en && !full)? w_bin_ptr + 1'b1 : w_bin_ptr;
   assign w_gray_ptr_nxt = w_bin_ptr_nxt ^ (w_bin_ptr_nxt >> 1);
   
   assign full_next = (w_gray_ptr_nxt == {~(r_gray_ptr_sync[width-1:width-2]),r_gray_ptr_sync[width-3:0]}); 
   
   always@(posedge w_clk or negedge w_rst)begin
     if(!w_rst)begin
       w_bin_ptr <= 0;
       w_gray_ptr <= 0;
       full <= 1'b0;
     end
     else begin
         w_bin_ptr <= w_bin_ptr_nxt;
         w_gray_ptr <= w_gray_ptr_nxt;
         full <= full_next;
     end
   end
endmodule
