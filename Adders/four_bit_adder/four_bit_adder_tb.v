`timescale 1ns / 1ps


module four_bit_adder_tb;
  reg [3:0]A,B,cin;
  wire [3:0]sum;
  wire cout;
  
  four_bit_adder m1(.A(A),.B(B),.cin(cin),.sum(sum),.cout(cout));
  integer i;
  initial begin
    $monitor("time = %d,A = %h,B = %h,sum = %h,cout = %b",$time,A,B,sum,cout);
    cin = 1'b0;
    for(i = 0; i < 5; i = i + 1)begin
        #10 {A,B} = $random;
    end
    #10 $finish;
  end
endmodule
