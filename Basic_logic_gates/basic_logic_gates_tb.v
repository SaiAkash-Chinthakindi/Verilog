`timescale 1ns / 1ps


module basic_logic_gates_tb;
  reg A,B;
  wire and_out,or_out,not_out_a,not_out_b,nor_out,nand_out,xor_out,xnor_out;
  
  basic_logic_gates m1(.A(A),.B(B),
                       .and_out(and_out),
                       .or_out(or_out),
                       .not_out_a(not_out_a),
                       .not_out_b(not_out_b),
                       .nor_out(nor_out),
                       .nand_out(nand_out),
                       .xor_out(xor_out),
                       .xnor_out(xnor_out));
                       
  initial begin
    A = 1'b0; B = 1'b0;
    #10 A = 1'b0; B = 1'b1;
    #10 A = 1'b1; B = 1'b0;
    #10 A = 1'b1; B = 1'b1;
    #10 $finish;
  end
endmodule
