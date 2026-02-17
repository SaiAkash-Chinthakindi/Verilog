`timescale 1ns / 1ps

module decimal_to_bcd(decimal_in,bcd_out);
  input [9:0]decimal_in;
  output reg [3:0]bcd_out;
  
  always@(*)begin
    case(decimal_in)
      10'b00000_00001 : bcd_out = 4'b0000;
      10'b00000_00010 : bcd_out = 4'b0001;
      10'b00000_00100 : bcd_out = 4'b0010;
      10'b00000_01000 : bcd_out = 4'b0011;
      10'b00000_10000 : bcd_out = 4'b0100;
      10'b00001_00000 : bcd_out = 4'b0101;
      10'b00010_00000 : bcd_out = 4'b0110;
      10'b00100_00000 : bcd_out = 4'b0111;
      10'b01000_00000 : bcd_out = 4'b1000;
      10'b10000_00000 : bcd_out = 4'b1001;
      default : bcd_out = 4'b0000;
     endcase
  end
endmodule
