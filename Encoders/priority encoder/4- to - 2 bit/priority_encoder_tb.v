`timescale 1ns / 1ps


module priority_encoder_tb;
  reg [3:0]A;
  wire [1:0]y;
  wire v;
  
  priority_encoder_4_2 m1(.A(A),.y(y),.v(v));
  
  initial begin
   $monitor("Time = %0d,A = %b,y = %b, v = %v",$time,A,y,v);
   repeat(5) begin
     A = $random; #10;
   end
   $finish;
  end
endmodule
