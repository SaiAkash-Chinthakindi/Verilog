`timescale 1ns / 1ps

module half_adder(A,B,sum,cout);
  input A,B;
  output sum,cout;
  
  assign sum = A ^ B;
  assign cout = A & B;
endmodule
