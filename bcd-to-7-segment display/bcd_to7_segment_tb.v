`timescale 1ns / 1ps


module bcd_to7_segment_tb;
  reg [3:0]bcd;
  wire a,b,c,d,e,f,g;
  
  bcd_to7_segment m1(.bcd_input(bcd),.a(a),.b(b),.c(c),.d(d),.e(e),.f(f),.g(g));
  
  initial begin
    for(integer i = 0; i <10; i = i + 1)begin
        bcd = i;
        #10;
    end
    $finish;
  end
endmodule
