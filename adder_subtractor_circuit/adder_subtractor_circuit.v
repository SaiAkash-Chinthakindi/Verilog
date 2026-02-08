`timescale 1ns / 1ps


module adder_subtractor_circuit(A,B,mode,sum,cout);
  input [3:0]A,B;
  input mode;
  output [3:0]sum;
  output cout;
  
  wire [2:0]w;
  
  sub_module m1(.A(A[0]),.B(B[0]),.mode(mode),.cin(mode),.sum(sum[0]),.cout(w[0]));
  sub_module m2(.A(A[1]),.B(B[1]),.mode(mode),.cin(w[0]),.sum(sum[1]),.cout(w[1]));
  sub_module m3(.A(A[2]),.B(B[2]),.mode(mode),.cin(w[1]),.sum(sum[2]),.cout(w[2]));
  sub_module m4(.A(A[3]),.B(B[3]),.mode(mode),.cin(w[2]),.sum(sum[3]),.cout(cout));
  
endmodule

module full_adder(A,B,cin,sum,cout);
  input A,B,cin;
  output sum,cout;
  
  assign sum = A ^ B ^ cin;
  assign cout = (( A & B) | cin&(A ^ B));
endmodule

module sub_module(A,B,cin,mode,sum,cout);
  input A,B,cin;
  input mode;
  output sum,cout;
  
  wire w1;
  
  xor m1(w1,B,mode);
  
  full_adder m5(.A(A),.B(w1),.cin(cin),.sum(sum),.cout(cout));
endmodule