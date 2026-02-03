`timescale 1ns / 1ps

module gray_to_binary_code(gray,binary);
  parameter N = 4;
  input [(N - 1):0]gray;
  output reg [(N - 1):0]binary;
  integer i;
  always@(*)begin
    for(i = (N - 1); i >= 0;i = i - 1)begin
      if(i == N-1)
        binary[i] = gray[i];
      else
        binary[i] = binary[i + 1] ^ gray[i];
    end
  end
  
endmodule
