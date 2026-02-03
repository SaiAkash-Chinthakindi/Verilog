`timescale 1ns / 1ps

// structural modeling
module full_adder(A,B,cin,sum,cout);
  input A,B,cin;
  output sum,cout;
  wire w1,w2,w3;
  
  half_adder m1(.A(A),.B(B),.sum(w1),.cout(w2));
  half_adder m2(.A(w1),.B(cin),.sum(sum),.cout(w3));
  
  assign cout = w2 | w3;
  
endmodule

// using continuous assignment
/* module full_adder(A,B,cin,sum,cout);
    input A,B,cin;
    output sum,cout;
   
    assign {cout,sum} = A + B + cin;
  endmodule*/
  
//using Behavioral modeling
/* module full_adder(A,B,cin,sum,cout);
     input A,B,cin;
     output reg sum,cout;
     
     always@(*)begin
       {cout,sum} = A + B + cin;
     end
   endmodule */
// gate level modeling   
/*module  full_adder(A,B,cin,sum,cout);
   input A,B,cin;
   output sum,cout;
   wire w1,w2,w2;
   
   xor m1(w1,A,B);
   and m2(w2,A,B);
   
   xor m3(sum,w1,cin);
   and m4(w3,w1,cin);
   
   or m5(cout,w2,w3);
endmodule */
