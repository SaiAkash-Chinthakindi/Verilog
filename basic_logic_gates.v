`timescale 1ns / 1ps


module basic_logic_gates(A,B,and_out,or_out,nand_out,nor_out,not_out_a,not_out_b,xor_out,xnor_out);
  input A,B;
  output and_out,or_out,nand_out,nor_out,not_out_a,not_out_b,xor_out,xnor_out;
  
  assign and_out = A & B;
  assign or_out = A | B;
  assign not_out_a = ~A;
  assign not_out_b = ~B;
  assign nand_out = ~(A & B);
  assign nor_out = ~(A | B);
  assign xor_out = A ^ B;
  assign xnor_out = ~(A ^ B);
  
endmodule
