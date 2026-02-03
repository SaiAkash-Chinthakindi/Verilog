`timescale 1ns / 1ps


module binary_to_gray1_tb;
   reg [7:0]binary;
   wire [7:0]gray;
   
   integer i;
   binary_to_gray1 #(.N(8)) m1(.binary(binary),.gray(gray));
   
   initial begin
     $monitor("time =%d,binary =%0xh,gray =%0xh",$time,binary,gray);
   end
   
   initial begin
     for(i = 0; i < 5; i = i + 1)begin
         #10 binary = $random;
     end
     #10 $finish;
   end
endmodule
