`timescale 1ns / 1ps


module T_FF(T,clk,rst,Q,Q_);
  input clk,rst;
  input T;
  output reg Q;
  output Q_;
  
  assign Q_ = ~Q;
  
  always@(posedge clk or negedge rst)begin
    if(!rst)
     Q <= 1'b0;
    else begin
     if(T)
      Q <= ~Q;
     else
      Q <= Q;
    end
  end
  
endmodule
