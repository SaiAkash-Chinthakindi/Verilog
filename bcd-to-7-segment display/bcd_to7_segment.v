`timescale 1ns / 1ps

module bcd_to7_segment(bcd_input,a,b,c,d,e,f,g);
  input [3:0]bcd_input;
  output reg a,b,c,d,e,f,g;
  
  always@(*)begin
    case(bcd_input)
      4'b0000: {a,b,c,d,e,f,g} = {{6{1'b1}},1'b0};
      4'b0001: {a,b,c,d,e,f,g} = {1'b0,{2{1'b1}},{4{1'b0}}};
      4'b0010: {a,b,c,d,e,f,g} = {1'b1,1'b1,1'b0,1'b1,1'b1,1'b0,1'b1};
      4'b0011: {a,b,c,d,e,f,g} = {{4{1'b1}},{2{1'b0}},1'b1};
      4'b0100: {a,b,c,d,e,f,g} = {1'b0,{2{1'b1}},{2{1'b0}},1'b1,1'b1};
      4'b0101: {a,b,c,d,e,f,g} = {1'b1,1'b0,1'b1,1'b1,1'b0,1'b1,1'b1};
      4'b0110: {a,b,c,d,e,f,g} = {1'b1,1'b0,{5{1'b1}}};
      4'b0111: {a,b,c,d,e,f,g} = {{3{1'b1}},{4{1'b0}}};
      4'b1000: {a,b,c,d,e,f,g} = {{7{1'b1}}};
      4'b1001: {a,b,c,d,e,f,g} = {{3{1'b1}},{2{1'b0}},{2{1'b1}}};
      default: {a,b,c,d,e,f,g} = {{7{1'b0}}};
    endcase;
  end
endmodule
