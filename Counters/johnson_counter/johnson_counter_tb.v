`timescale 1ns / 1ps


module johnson_counter_tb;
  reg clk,rst;
  wire [3:0]q;
  
  johnson_counter m1(.clk(clk),.rst(rst),.q(q));
  
  initial begin
    clk = 1'b0;
    rst = 1'b0;
    
    @(negedge clk) rst = 1'b1;
    @(negedge clk) rst = 1'b0;
    
    repeat(8) @(negedge clk);
    
    $finish;
  end
  always #10 clk = ~clk;
endmodule
