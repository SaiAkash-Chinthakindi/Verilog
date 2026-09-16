`timescale 1ns / 1ps


module FIFO_memory #(parameter depth = 8,data_width = 8)(w_clk,r_clk,w_en,r_en,full,empty,data_in,data_out,w_rst,r_rst);
     parameter addr = $clog2(depth);
     
     input w_clk,r_clk;
     input w_en,r_en;
     input w_rst,r_rst;
     output full,empty;
     input [data_width-1:0]data_in;
     output reg [data_width-1:0]data_out;
     
     reg [data_width-1:0]mem[depth-1:0];
     
     wire [addr:0]r_gray_ptr_sync,w_gray_ptr_sync;
     wire [addr:0]w_ptr,r_ptr;
     wire [addr:0]r_gray_ptr,w_gray_ptr;
     
     always@(posedge w_clk)begin
       if(w_en && !full)begin
         mem[w_ptr[addr-1:0]] <= data_in;
       end
     end
     
     always@(posedge r_clk)begin
       if(r_en && !empty)begin
          data_out <= mem[r_ptr[addr-1:0]];
       end
     end
     //assign data_out = mem[r_ptr[addr-1:0]];
     
     write_pointer #(.width(addr+1))u1(.w_clk(w_clk),.w_rst(w_rst),.w_en(w_en),.w_bin_ptr(w_ptr),.w_gray_ptr(w_gray_ptr),.r_gray_ptr_sync(r_gray_ptr_sync),.full(full));
     Synchronizers #(.width(addr+1)) s1(.clk(w_clk),.rst(w_rst),.data_in(r_gray_ptr),.data_out(r_gray_ptr_sync));
     
     read_pointer #(.width(addr+1)) u2(.r_clk(r_clk),.r_rst(r_rst),.r_en(r_en),.r_bin_ptr(r_ptr),.r_gray_ptr(r_gray_ptr),.w_gray_ptr_sync(w_gray_ptr_sync),.empty(empty));
     Synchronizers #(.width(addr+1)) s2(.clk(r_clk),.rst(r_rst),.data_in(w_gray_ptr),.data_out(w_gray_ptr_sync));
     
endmodule
