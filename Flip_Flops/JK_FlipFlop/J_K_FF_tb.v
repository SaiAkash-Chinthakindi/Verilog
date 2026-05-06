`timescale 1ns / 1ps

module J_K_FF_tb;
  reg J,K;
  reg clk,rst;
  wire Q,Q_;
  
  J_K_FF m1(.clk(clk),.rst(rst),.J(J),.K(K),.Q(Q),.Q_(Q_));
  
  initial begin
    clk = 1'b0;
    rst = 1'b1;
    
    @(posedge clk) rst = 1'b0;
    @(posedge clk) rst = 1'b1;
    
    for(integer i = 0; i <4; i = i + 1)begin
      {J,K} = i;
      @(negedge clk);
    end
    $finish;
  end
  
  always #5 clk = ~clk;
endmodule
