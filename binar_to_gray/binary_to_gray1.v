`timescale 1ns / 1ps


module binary_to_gray1(binary,gray);
  parameter N = 4;
  input [(N - 1'b1):0]binary;
  output reg[(N - 1'b1):0]gray;
  
  integer i;
  always@(*)begin
    for(i = (N - 1); i >=0; i = i-1'b1)begin
        if(i == (N - 1'b1))
           gray[i] = binary[i];
        else
           gray[i] = binary[i] ^ binary[i + 1'b1];
    end
  end
endmodule
