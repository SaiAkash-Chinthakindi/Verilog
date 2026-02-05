`timescale 1ns / 1ps

module four_bit_adder(A,B,cin,sum,cout);
  input [3:0]A,B;
  input cin;
  output [3:0]sum;
  output cout;
  
  wire [2:0]w;
  
  full_adder m1(.A(A[0]),.B(B[0]),.cin(1'b0),.sum(sum[0]),.cout(w[0]));
  full_adder m2(.A(A[1]),.B(B[1]),.cin(w[0]),.sum(sum[1]),.cout(w[1]));
  full_adder m3(.A(A[2]),.B(B[2]),.cin(w[1]),.sum(sum[2]),.cout(w[2]));
  full_adder m4(.A(A[3]),.B(B[3]),.cin(w[2]),.sum(sum[3]),.cout(cout));
  
endmodule
