`timescale 1ns / 1ps

module half_adder_tb;
  reg A,B;
  wire sum,cout;
  
  half_adder m1(.A(A),.B(B),.sum(sum),.cout(cout));
  integer i;
  initial begin
    $monitor("time =%d,A = %d,B = %b,sum = %b,cout = %b",$time,A,B,sum,cout);
    for(i = 0; i < 4; i = i + 1)begin
       #10 {A,B} = i;
       end
     #10 $finish;
  end
endmodule
