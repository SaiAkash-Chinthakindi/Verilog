`timescale 1ns / 1ps

module NOR_mux(A,B,y);
  input A,B;
  output y;
  
  wire A_;
  
  mux2_1 m5_0(.I1(1'b0),.I0(1'b1),.sel(A),.y(A_));
  mux2_1 m5_1(.I1(1'b0),.I0(A_),.sel(B),.y(y));
  
endmodule
