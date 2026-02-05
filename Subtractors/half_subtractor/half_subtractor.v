`timescale 1ns / 1ps

// using continous assignment
module half_subtractor(A,B,diff,d_out);
  input A,B;
  output diff,d_out;
  
  assign diff = A ^ B;
  assign d_out = ~A & B;
endmodule

/* using gate level modeling
module half_subtractor(A,B,diff,d_out);
   input A,B;
   output diff,d_out;
   
   wire w1;
   
   xor m1(diff,A,B);
   not m2(w1,A);
   and m3(d_out,w1,B);
   
endmodule */

/* using behavioual modeling
module half_subtractor(A,B,diff,d_out);
  input A,B;
  output reg diff,d_out;
  
  always@(*)begin
    diff = A ^ B;
    d_out = ~A & B;
  end
endmodule */