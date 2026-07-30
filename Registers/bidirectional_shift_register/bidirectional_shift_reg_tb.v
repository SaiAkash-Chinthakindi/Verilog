`timescale 1ns / 1ps

module bidirectional_shift_reg_tb();
   parameter N = 4;
   reg clk;
   reg rst;
   reg data_in;
   reg shift_op;
   wire [N-1:0]data_out;
   
   bidirectional_shift_reg m1(.clk(clk),.rst(rst),.data_in(data_in),.shift_op(shift_op),.data_out(data_out));
   
   initial begin
     clk = 0;
     rst = 1;
     data_in = 0;
     
     $monitor("time = %0d,shift-operation = %0b, data_out = %b",$time,shift_op,data_out);
     
     @(negedge clk) rst = 0;
     @(negedge clk);
     @(negedge clk) rst = 1;
     
     shift_op = 0;
     repeat(N) begin
       @(negedge clk) data_in = ~data_in;
     end
     
     @(negedge clk) shift_op = 1'b1;
     repeat(3)begin
        @(negedge clk) data_in = 0;
     end
     $finish;
   end
   always #5 clk = ~clk;
endmodule
