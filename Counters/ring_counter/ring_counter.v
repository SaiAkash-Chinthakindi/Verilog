`timescale 1ns / 1ps

module ring_counter(clk,preset,q);
  input clk,preset;
  output [3:0]q;
  reg [3:0]q;
  
  initial q <= 4'b0;
  
  always@(posedge clk,negedge preset)begin
     if(!preset)
        q <= 4'b1000;
     else 
        //q[3] <= q[0];
        //q[2] <= q[3];
        //q[1] <= q[2];
        //q[0] <= q[1];
        q <= {q[0],q[3:1]};
  end
endmodule
