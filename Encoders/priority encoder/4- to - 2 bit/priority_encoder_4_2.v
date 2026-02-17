`timescale 1ns / 1ps


module priority_encoder_4_2(A,y,v);
  input [3:0]A;
  output reg [1:0]y;
  output v;
  
  assign v = |A;
  always@(*)begin
    casex(A)
      4'b1xxx : y = 2'b11;
      4'b01xx : y = 2'b10;
      4'b001x : y = 2'b01;
      4'b0001 : y = 2'b00;
      default : y = 2'b00;
    endcase
  end
endmodule
