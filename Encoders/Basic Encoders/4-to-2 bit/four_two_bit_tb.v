`timescale 1ns / 1ps


module four_two_bit_tb ;
  reg [3:0]A;
  wire [1:0]y;
  
  four_two_bit m1(.A(A),.y(y));
  
  initial begin
    $monitor("Time = %0d, A = %b, y = %b",$time,A,y);
    A = 4'b1000; #10;
    A = 4'b0100; #10;
    A = 4'b0010; #10;
    A = 4'b0001; #10;
    $finish;
  end
  
endmodule
