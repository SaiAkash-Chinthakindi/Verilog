`timescale 1ns / 1ps


 module full_subtractor(A,B,d_in,diff,d_out);
   input A,B,d_in;
   output diff,d_out;
   
   wire [2:0]w;
   
   half_subtractor m1(.A(A),.B(B),.diff(w[0]),.d_out(w[1]));
   half_subtractor m2(.A(w[0]),.B(d_in),.diff(diff),.d_out(w[2]));
   
   assign d_out = w[1] | w[2];
 endmodule 

/*
module full_subtractor(A,B,d_in,diff,d_out);
   input A,B,d_in;
   output diff,d_out;
   
   assign {diff,d_out} = A-B-d_in;
endmodule*/
