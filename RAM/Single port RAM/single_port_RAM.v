`timescale 1ns / 1ps


module single_port_RAM(clk,rst,en,wr,addr,data_in,data_out);
   input clk,rst;
   input [2:0]addr;
   input en,wr;
   input [7:0]data_in;
   output reg [7:0]data_out;
   
   reg [7:0]mem[7:0];
   
   initial begin
     data_out = 8'd0;
   end
   
   always@(posedge clk or posedge rst)begin
    if(rst)begin
      data_out <= 0;
    end
    else begin
    if(en)begin
     if(wr)
       mem[addr] <= data_in;
     else
       data_out <= mem[addr];
    end
    else
     data_out <= data_out;
   end
  end
endmodule
