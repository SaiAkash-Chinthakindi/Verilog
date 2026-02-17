`timescale 1ns / 1ps


module eight_to_three_bit(A,y,v);
   input [7:0]A;
   output reg [2:0]y;
   output v;
   
   assign v = (A == 8'b0000_0001)? 1'b1 : 0;
   
   always@(*)begin
     case(A)
       8'b1000_0000 : y = 3'b111;
       8'b0100_0000 : y = 3'b110;
       8'b0010_0000 : y = 3'b101;
       8'b0001_0000 : y = 3'b100;
       8'b0000_1000 : y = 3'b011;
       8'b0000_0100 : y = 3'b010;
       8'b0000_0010 : y = 3'b001;
       8'b0000_0001 : y = 3'b000;
       default : y = 3'b000;
     endcase
   end
endmodule
