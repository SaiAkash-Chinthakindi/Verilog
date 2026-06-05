`timescale 1ns / 1ps

module gates_using_mux(A,B,y,sel);
  input A,B;
  input [2:0]sel;
  output reg y;
  
  wire AND_output,OR_output,NOT_output,NAND_output,NOR_output,XOR_output,XNOR_output;
  
  AND_mux i1(.A(A),.B(B),.y(AND_output));
  OR_mux i2(.A(A),.B(B),.y(OR_output));
  NOT_mux i3(.A(A),.y(NOT_output));
  NAND_mux i4(.A(A),.B(B),.y(NAND_output));
  NOR_mux i5(.A(A),.B(B),.y(NOR_output));
  XOR_mux i6(.A(A),.B(B),.y(XOR_output));
  XNOR_mux i7(.A(A),.B(B),.y(XNOR_output));
  
  always@(*)begin
    case(sel)
       3'b000 : y = AND_output;
       3'b001 : y = OR_output;
       3'b010 : y = NOT_output;
       3'b011 : y = NAND_output;
       3'b100 : y = NOR_output;
       3'b101 : y = XOR_output;
       3'b110 : y = XNOR_output;
       default : y = 0;
    endcase
  end
endmodule
