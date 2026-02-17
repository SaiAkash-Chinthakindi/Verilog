`timescale 1ns / 1ps

module priority_encoder_8_3_tb ;
  reg [7:0]A;
  wire [2:0]y;
  wire v;
  
  priority_encoder_8_3 m1(.A(A),.y(y),.v(v));
  
  initial begin
    $monitor("Time = %0d, A = %b, y = %b, v = %b",$time,A,y,v);
    A = 8'b0;
    #10;
    for(integer i= 0; i < 8; i = i + 1)begin
       A = $random;
       #10;
    end
    $finish;
  end
endmodule
