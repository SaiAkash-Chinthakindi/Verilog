`timescale 1ns / 1ps


module D_FF(D,clk,rst,Q,Q_);
  input D;
  input clk,rst;
  output reg Q,Q_;
  
  always@(posedge clk or negedge rst)begin
    if(!rst)
     {Q,Q_} <= 2'b01;
    else begin
     case(D)
      1'b1 : {Q,Q_} <= 2'b10;
      1'b0 : {Q,Q_} <= 2'b01;
      default : {Q,Q_} <= {Q,Q_};
     endcase
    end
  end
endmodule

/*
module D_FF(D,clk,rst,Q,Q_);
  input D;
  input clk,rst;
  output reg Q;
  output Q_;
  
  assign Q_ = ~Q;
  
  always@(posedge clk or negedge rst)begin
    if(!rst)
     Q = 0;
    else 
     Q <= D;
  end
endmodule

*/

