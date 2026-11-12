`timescale 1ns / 1ps

module mealy_machine2(clk,rst_n,in,out);
  localparam s0 = 3'b000,s1 = 3'b001,s2 = 3'b010,s3 = 3'b011,s4 = 3'b100,s5 = 3'b101;
  input clk;
  input rst_n;
  input in;
  output out;
  
  reg [2:0]state,next_state;
  
  assign out = (state == s5) && (in == 1'b1);
  
  always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
      state <= s0;
    end
    else
      state <= next_state;
  end
  
  always@(*)begin
    case(state) 
      s0 : begin
             if(in == 1'b1)
                next_state = s1;
             else 
                next_state = s0;
           end
      s1 : begin
             if(in == 1'b1)
                next_state = s2;
             else
                next_state = s0;
           end
      s2 : begin
              if(in == 1'b0)
                next_state = s3;
              else
                next_state = s2;
           end
      s3 : begin
              if(in == 1'b1)
                next_state = s4;
              else
                next_state = s0;
           end
      s4 : begin
               if(in == 1'b0)
                 next_state = s5;
               else
                 next_state = s2;
           end
      s5 : begin
               if(in == 1'b1)
                 next_state = s0;
               else
                 next_state = s0;
           end
      default : next_state = s0;
     endcase
  end
endmodule
