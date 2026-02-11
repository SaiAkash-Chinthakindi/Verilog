`timescale 1ns / 1ps


module full_subtractor_tb;
  reg A,B,d_in;
  wire diff,d_out;
  
  full_subtractor m1(.A(A),.B(B),.d_in(d_in),.diff(diff),.d_out(d_out));
  
  initial begin
    $monitor("Time = %0d,A = %b,B = %b,d_in = %b,diff = %b,d_out = %b",$time,A,B,d_in,diff,d_out);
    for(integer i = 0; i < 8; i = i + 1)begin
      {A,B,d_in} = i;
      #10;
    end
    $finish;
  end
endmodule
