`timescale 1ns / 1ps


module single_port_RAM_tb ;
  reg clk,rst,en,wr;
  reg [2:0]addr;
  reg [7:0]data_in;
  wire [7:0]data_out;
  
  integer seed = 6;
  single_port_RAM m1(.clk(clk),.rst(rst),.en(en),.wr(wr),.addr(addr),.data_in(data_in),.data_out(data_out));
  
  initial begin
    $monitor("enable = %b, write/read = %b, address = %d, data_in = %b , data_out = %b",en,wr,addr,data_in,data_out);
    clk = 1'b0;
    rst = 1'b0;
    wr <= 0;
    en <= 0;
    
    @(negedge clk) rst = 1'b1;
    @(negedge clk) rst = 1'b0;
    
    @(negedge clk) begin 
      en = 1'b1;
      wr = 1'b1;
    end
    for(integer i = 0; i <8; i = i + 1)begin
       addr = i;
       data_in = $random(seed);
       @(negedge clk);
    end
    
    @(negedge clk)begin 
      en = 1'b1;
      wr = 1'b0;
    end
    repeat(8) begin
      addr = $random(seed);
      @(negedge clk);
    end
    
    en = 1'b0;
    @(negedge clk);
    
    $finish;
  end
  
  always #10 clk = ~clk;
endmodule
