`timescale 1ns / 1ps


module OR_mux(A,B,y);
  input A,B;
  output y;
  
  mux2_1 m2(.I1(1'b1),.I0(A),.sel(B),.y(y));
  
  
endmodule
