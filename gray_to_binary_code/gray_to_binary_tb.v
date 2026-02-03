`timescale 1ns / 1ps


module gray_to_binary_tb ;
  reg [7:0]gray;
  wire [7:0]binary;
  integer i;
  gray_to_binary_code #(.N(8)) m1(.gray(gray),.binary(binary));
  
  initial begin
    $monitor("time = %d, gray = %h, binary = %h",$time,gray,binary);
    for(i = 0; i < 5; i = i + 1)begin
      #10 gray = $random;
    end
    #10 $finish;
  end
endmodule
