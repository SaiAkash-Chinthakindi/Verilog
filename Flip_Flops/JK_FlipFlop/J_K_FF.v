`timescale 1ns / 1ps

module J_K_FF(J,K,clk,rst,Q,Q_);
  input J,K;
  input clk,rst;
  output reg Q;
  output Q_;
  
  assign Q_ = ~Q;
  
  always@(posedge clk or negedge rst)begin
   if(!rst)
     Q <= 1'b0;
   else begin
     case({J,K})
      2'b00 : Q <= Q;
      2'b01 : Q <= 1'b0;
      2'b10 : Q <= 1'b1;
      2'b11 : Q <= ~Q;
      default : Q <= Q;
     endcase
   end
  end
endmodule


/*
module J_K_FF(J,K,clk,rst,Q,Q_);
  input J,K;
  input clk,rst;
  output reg Q,Q_;
  
  always@(posedge clk or negedge rst)begin
   if(!rst)
     {Q,Q_} <= 2'b01;
   else begin
     case({J,K})
      2'b00 : {Q,Q_} <= {Q,Q_};
      2'b01 : {Q,Q_} <= 2'b01;
      2'b10 : {Q,Q_} <= 2'b10;
      2'b11 : {Q,Q_} <= ~{Q,Q_};
      default : {Q,Q_} <= {Q,Q_};
     endcase
   end
  end
endmodule

*/