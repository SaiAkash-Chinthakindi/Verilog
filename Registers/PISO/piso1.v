`timescale 1ns / 1ps


module piso1(in,load,clk,rst,q);
  input [3:0]in;
  input load,clk,rst;
  output q;
  
  wire w1,w2,w3,w4,w5,w6,w7;
  
  mux_dff m1 (.in0(1'b0),.in1(in[3]),.load(load),.clk(clk),.rst(rst),.q(w1));
  mux_dff m2 (.in0(w1),.in1(in[2]),.load(load),.clk(clk),.rst(rst),.q(w2));
  mux_dff m3 (.in0(w2),.in1(in[1]),.load(load),.clk(clk),.rst(rst),.q(w3));
  mux_dff m4 (.in0(w3),.in1(in[0]),.load(load),.clk(clk),.rst(rst),.q(q));
  
  
endmodule


module d_ff(in,clk,rst,q);
  input in,clk,rst;
  output reg q;
  
  always@(posedge clk)begin
    if(rst)
      q <= 1'b0;
    else
      q <= in;
  end
endmodule

module mux_2x1(in,sel,q);
  input [1:0]in;
  input sel;
  output reg q;
  always@(*)begin
  case(sel)
    1'b1: q = in[1];
    1'b0: q = in[0];
    default : q = in[0];
    endcase
  end
endmodule

module mux_dff(in0,in1,load,clk,rst,q);
  input in0,in1,clk,rst,load;
  output q;
  
  wire w1;
  
  mux_2x1 m1(.in({in1,in0}),.sel(load),.q(w1));
  d_ff m2(.in(w1),.clk(clk),.rst(rst),.q(q));
endmodule