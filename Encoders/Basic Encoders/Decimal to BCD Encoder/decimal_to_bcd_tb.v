`timescale 1ns / 1ps

module decimal_to_bcd_tb ;
  reg [9:0]decimal_in;
  wire [3:0]bcd_out;
  
  decimal_to_bcd m1(.decimal_in(decimal_in),.bcd_out(bcd_out));
  
  initial begin
    $monitor("time = %0d, decimal = %b, bcd_out = %b",$time,decimal_in,bcd_out);
    decimal_in = 10'b0;
    #10;
    for(integer i = 0; i < 10; i = i +1)begin
      if(i == 0)
        decimal_in = 10'b00000_00001;
      else
        decimal_in = decimal_in << 1'b1;
      #10;
    end
    $finish;
  end
endmodule
