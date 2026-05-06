`timescale 1ns / 1ps


module D_FF_tb ;
  reg D,clk,rst;
  wire Q,Q_;
  
  D_FF m1(.clk(clk),.rst(rst),.D(D),.Q(Q),.Q_(Q_));
  
  initial begin
      clk = 0;
      rst = 0;
      D = 0;
  
      @(posedge clk) rst = 1;
  
      D = 0;
      @(negedge clk);
  
      D = 1;
      @(negedge clk);
  
      D = 0;
      @(negedge clk);
  
      D = 1;
      @(negedge clk);
  
      $finish;
    end
  
  always #5 clk = ~clk;
endmodule
