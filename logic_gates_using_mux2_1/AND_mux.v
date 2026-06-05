`timescale 1ns / 1ps

module AND_mux(A,B,y);
  input A,B;
  output y;
  
  mux2_1 m1(.I1(A),.I0(1'b0),.sel(B),.y(y));
  
  
endmodule
