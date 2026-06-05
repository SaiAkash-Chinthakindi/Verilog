`timescale 1ns / 1ps

module XOR_mux(A,B,y);
  input A,B;
  output y;
  
  wire A_;
  
  mux2_1 m6_0(.I1(1'b0),.I0(1'b1),.sel(A),.y(A_));
  mux2_1 m6_1(.I1(A_),.I0(A),.sel(B),.y(y));
  
endmodule
