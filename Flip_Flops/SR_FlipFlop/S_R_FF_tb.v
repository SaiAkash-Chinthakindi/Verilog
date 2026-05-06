`timescale 1ns / 1ps

module S_R_FF_tb;
  reg S,R;
  reg clk,rst;
  wire Q,Q_;
  
  S_R_FF m1(.S(S),.R(R),.clk(clk),.rst(rst),.Q(Q),.Q_(Q_));
  
  initial begin
    clk = 1'b0;
    rst = 1'b1;
    
    @(posedge clk) rst = 0;
    @(posedge clk);
    @(posedge clk) rst = 1;
    
    for(integer i = 0; i < 4; i = i + 1)begin
      {S,R} = i;
      @(negedge clk);
    end
    @(negedge clk) $finish;
  end
  always #5 clk = ~clk;
endmodule
