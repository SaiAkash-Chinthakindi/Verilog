`timescale 1ns / 1ps

module four_bit_odd_parity_tb;
  parameter N = 4;
  reg [(N - 1):0]A;
  wire parity;
  wire [N : 0]parity_data;
   
  four_bit_odd_parity_generator #(4) m1(.data(A),.parity(parity),.parity_data(parity_data));
  
  initial begin
    $monitor("Time = %0d, data = %b, parity = %b",$time,A,parity);
    for(integer i = 0; i < 16; i = i + 1)begin
      A = i;
      #10;
    end
    $finish;
  end
endmodule
