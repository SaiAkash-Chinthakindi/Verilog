`timescale 1ns / 1ps

module mux2_1(I0,I1,sel,y);
  input I0,I1;
  input sel;
  output reg y;
  
  always@(*)begin
    if(sel)
      y = I1;
    else
      y = I0;
  end
endmodule

/*
module mux2_1(I0,I1,sel,y);
  input I0,I1;
  input sel;
  output y;
  
  assign y = sel ? I1 : I0;
  
endmodule
*/