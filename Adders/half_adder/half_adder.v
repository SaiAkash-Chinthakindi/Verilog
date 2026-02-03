`timescale 1ns / 1ps

module half_adder(A,B,sum,cout);
  input A,B;
  output sum,cout;
  
  assign sum = A ^ B;
  assign cout = A & B;
endmodule


//gate level implementation

/*module half_adder(A,B,sum,cout);
  input A,B;
  output sum,cout;
  
  xor m1(sum,A,B);
  and m2(cout,A,B);
endmodule*/