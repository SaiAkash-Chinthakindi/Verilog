`timescale 1ns / 1ps


module read_pointer #(parameter width = 4)(r_clk,r_rst,r_en,r_bin_ptr,r_gray_ptr,w_gray_ptr_sync,empty);
   input r_clk;
   input r_rst;
   input r_en;
   input [width-1:0]w_gray_ptr_sync;
   output reg[width-1:0]r_bin_ptr;
   output reg[width-1:0]r_gray_ptr;
   output reg empty;
   
   wire [width-1:0]r_bin_ptr_nxt;
   wire [width-1:0]r_gray_ptr_nxt;
   wire empty_next;
   
   assign r_bin_ptr_nxt = (r_en && !empty)? r_bin_ptr + 1'b1 : r_bin_ptr;
   assign r_gray_ptr_nxt = r_bin_ptr_nxt ^ (r_bin_ptr_nxt >> 1);
   
   assign empty_next = (r_gray_ptr_nxt == w_gray_ptr_sync);
   
   always@(posedge r_clk or negedge r_rst)begin
     if(!r_rst)begin
       r_bin_ptr <= 0;
       r_gray_ptr <= 0;
       empty <= 1'b1;
     end
     else begin
       r_bin_ptr <= r_bin_ptr_nxt;
       r_gray_ptr <= r_gray_ptr_nxt;
       empty <= empty_next;
     end
   end
   
endmodule
