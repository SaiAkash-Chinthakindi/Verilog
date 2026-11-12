`timescale 1ns / 1ps

// 10110 non-overlaping melay sequence detector
module mealy_machine1(in,clk,rst_n,out);
   localparam s0 = 3'b000, s1 = 3'b001, s2 = 3'b010, s3 = 3'b011, s4 = 3'b100;
   input in;
   input rst_n;
   input clk;
   output out;
   
   reg [2:0]state, next_state;
   
   assign out = ((state == s4) && (in == 1'b0)) ? 1'b1 : 1'b0;
   
   always@(posedge clk or negedge rst_n)begin
     if(!rst_n)begin
       state <= s0;
     end
     else begin
       state <= next_state;
     end
   end
   
   always@(*)begin
     next_state = state;
     
     case(state)
        s0 : begin
               if(in == 1'b1)
                  next_state = s1;
               else
                  next_state = s0;
             end
        s1 : begin
                if(in == 1'b0)
                  next_state = s2;
                else
                  next_state = s1;
             end
        s2 : begin
               if(in == 1'b1)
                  next_state = s3;
               else
                  next_state = s0;
             end
        s3 : begin
               if(in == 1'b1)
                 next_state = s4;
               else
                 next_state = s2;
             end
        s4 : begin 
               if(in == 1'b0)
                 next_state = s0;
               else 
                 next_state = s1;
             end
        default : next_state = s0;
      endcase
   end
   
endmodule
