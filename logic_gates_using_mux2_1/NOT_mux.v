`timescale 1ns / 1ps

module NOT_mux(A,y);
  input A;
  output y;
  
  mux2_1 m3(.I1(1'b0),.I0(1'b1),.sel(A),.y(y));
  
  
endmodule
