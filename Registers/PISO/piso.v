`timescale 1ns / 1ps


module piso(in,load,clk,rst,q);
  input [3:0]in;
  input load,clk,rst;
  output q;
  
  wire w1,w2,w3,w4,w5,w6,w7;
  
  mux_2x1 m1(.in({in[3],1'b0}),.sel(load),.q(w1));
  mux_2x1 m2(.in({in[2],w2}),.sel(load),.q(w3));
  mux_2x1 m3(.in({in[1],w4}),.sel(load),.q(w5));
  mux_2x1 m4(.in({in[0],w6}),.sel(load),.q(w7));
  
  d_ff m5(.in(w1),.clk(clk),.rst(rst),.q(w2));
  d_ff m6(.in(w3),.clk(clk),.rst(rst),.q(w4));
  d_ff m7(.in(w5),.clk(clk),.rst(rst),.q(w6));
  d_ff m8(.in(w7),.clk(clk),.rst(rst),.q(q));
  
  
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