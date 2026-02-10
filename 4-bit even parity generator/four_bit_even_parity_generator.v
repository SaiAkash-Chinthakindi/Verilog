`timescale 1ns / 1ps


module four_bit_even_parity_generator(data,parity,parity_data);
  parameter N = 4;
  input [(N - 1):0]data;
  output parity;
  output [N :0] parity_data;
  
  assign parity = ^data;
  assign parity_data = {parity,data};
  
endmodule
