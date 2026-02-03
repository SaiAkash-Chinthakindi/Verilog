`timescale 1ns / 1ps


module full_adder_tb;
   reg A,B,cin;
   wire sum,cout;
   
   full_adder m1(.A(A),.B(B),.cin(cin),.cout(cout),.sum(sum));
   integer i;
   initial begin
     $monitor("time = %d,A = %b,B = %b,cin = %b,sum = %b,cout = %b",$time,A,B,cin,sum,cout);
     for(i = 0; i < 8; i = i + 1)begin
        #10{A,B,cin} = i;
     end 
     #10 $finish;
   end
endmodule
