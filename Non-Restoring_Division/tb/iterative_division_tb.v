`timescale 1ns / 1ps

module iterative_division_tb;
   parameter width = 5;
   reg clk,rst;
   reg [width-1:0]Dividend,divisor;
   reg start;
   wire [width-1:0]Quotient,remainder;
   wire done;
   wire [1:0]state1;
   wire [width-1:0]U_test,V_test;
   wire q1;
   
   iterative_division m1(.q1(q1),.U_test(U_test),.V_test(V_test),.state1(state1),.clk(clk),.rst(rst),.Dividend(Dividend),.Divisor(divisor),.start(start),.Quotient(Quotient),.remainder(remainder),.done(done));
   
   initial begin
     clk = 0;
     rst = 1;
     
     @(negedge clk) rst = 1'b0;
     @(negedge clk) rst = 1'b1;
     
     @(negedge clk) begin 
          Dividend = 5'b00111;
          divisor = 5'b00011;
          start = 1'b1;
        end
     
     @(negedge clk) start = 1'b0;
     
     repeat(10) @(negedge clk);
     
     $finish;
   end
   always #5 clk = ~clk;
endmodule
