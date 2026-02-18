`timescale 1ns / 1ps


module traffic_light_controller_tb ;
   reg clk,rst;
   reg vehicle_overload;
   reg button_EW,button_NS;
   wire [2:0]output_NS,output_EW; 
   wire output_PN,output_PE;
   wire [4:0]duration_O;
   
   traffic_light_controller m1(.clk(clk),.rst(rst),.vehicle_overload(vehicle_overload),.output_NS(output_NS),.output_EW(output_EW),.output_PN(output_PN),.output_PE(output_PE),.duration_O(duration_O),.button_NS(button_NS),.button_EW(button_EW));
   
   initial begin
     clk = 1'b0;
     rst = 1'b0;
     vehicle_overload = 1'b0;
     {button_NS,button_EW} = 2'b00;
   end
   
   initial begin
     @(negedge clk) rst = 1'b1;
     @(negedge clk) rst = 1'b0;
     
     repeat(14) @(negedge clk);
     
     @(negedge clk) vehicle_overload = 1'b1;
     @(negedge clk) vehicle_overload = 1'b0;
     
     wait (output_EW == 3'b001)
     
     repeat(3) @(negedge clk);
     
     @(negedge clk) button_NS = 1'b1;
     @(negedge clk) button_NS = 1'b0; 
     
   end
   
   initial begin
       $monitor("t=%0t rst=%b NS=%b EW=%b PN=%b PE=%b",$time, rst, output_NS, output_EW, output_PN, output_PE);
     end
   
   always #5 clk = ~clk;
   
   initial #1000 $finish;
endmodule
