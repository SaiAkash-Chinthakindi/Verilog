`timescale 1ns / 1ps

module half_subtractor_tb;
  reg A,B;
  wire diff,d_out;
  
  half_subtractor m1(.A(A),.B(B),.diff(diff),.d_out(d_out));
  
  initial begin
    $monitor("Time = %d, A = %b,B = %b, diff = %b,d_out = %b",$time,A,B,diff,d_out);
    for(integer i = 0; i < 4; i = i + 1)begin
      #10 {A,B} = i;
    end
    #10 $finish;
  end
endmodule
