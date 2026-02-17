`timescale 1ns / 1ps

module eight_to_three_bit_tb;
  reg [7:0]A;
  wire [2:0]y;
  wire v;
  
  eight_to_three_bit m1(.A(A),.y(y),.v(v));
  
 
  initial begin
    $monitor("Time = %0d, A = %b, y = %b, v = %b",$time,A,y,v);
    A = 8'b0000_0001; #10;
    for(integer i = 1; i < 8; i = i + 1)begin
       A = A << 1'b1;
       #10;
    end
    $finish;
  end
endmodule
