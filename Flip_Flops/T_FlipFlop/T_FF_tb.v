`timescale 1ns / 1ps


module T_FF_tb ;
 reg clk,rst;
 reg T;
 wire Q,Q_;
 
 T_FF m1(.clk(clk),.rst(rst),.T(T),.Q(Q),.Q_(Q_));
 
 initial begin
   clk = 1'b0;
   rst = 1'b1;
   
   @(posedge clk) rst = 1'b0;
   @(posedge clk) rst = 1'b1;
   
   repeat(2)begin
    T = 1'b0;
    @(negedge clk);
    
    T = 1'b1;
    @(negedge clk);
   end
   
   $finish;
 end
 
 always #5 clk = ~clk;
endmodule
