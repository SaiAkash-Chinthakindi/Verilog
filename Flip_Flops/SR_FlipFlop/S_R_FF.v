`timescale 1ns / 1ps

module S_R_FF(S,R,clk,rst,Q,Q_);
  input S,R;
  input clk,rst;
  output reg Q,Q_;
  
  always@(posedge clk or negedge rst)begin
    if(!rst)begin
     {Q,Q_} <= 2'b01;
    end
    else begin
      case({S,R})
        2'b00 : {Q,Q_} <= {Q,Q_};
        2'b01 : {Q,Q_} <= 2'b01;
        2'b10 : {Q,Q_} <= 2'b10;
        2'b11 : {Q,Q_} <= 2'bxx;
        default : {Q,Q_} <= 2'b01;
      endcase
    end
  end
endmodule
