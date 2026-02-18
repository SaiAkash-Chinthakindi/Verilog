`timescale 1ns / 1ps

module traffic_light_controller(clk,rst,vehicle_overload,output_NS,output_EW,output_PN,output_PE,duration_O,button_EW,button_NS);
  input clk,rst;
  input button_EW,button_NS;
  input vehicle_overload;
  output reg [2:0]output_NS,output_EW;
  output output_PN,output_PE;
  output [4:0]duration_O;
  
  parameter s0 = 3'b000,s1 = 3'b001,s2 = 3'b010, s3 = 3'b011, s4 = 3'b100;
  parameter green = 3'b001,yellow = 3'b010,red = 3'b100;
  parameter red_d = 4'd10,yellow_d=4'd3,green_d = 4'd15,extra_d = 5'd20;
  
  reg [2:0]state,next_state;
  reg [4:0]duration,next_duration;
  reg ew_ff1,ew_ff2,ew_ff_prev;
  reg ns_ff1,ns_ff2,ns_ff_prev;
  wire NS_pulse,EW_pulse;
  
  assign output_PN = (state == s0)? 1'b1 : 1'b0;
  assign output_PE = (state == s3)? 1'b1 : 1'b0;
  assign duration_O = duration;
  
  always@(posedge clk, posedge rst)begin
    if(rst)begin
      ew_ff1 <= 0;
      ew_ff2 <= 0;
      ew_ff_prev <= 0;
      
      ns_ff1 <= 0;
      ns_ff2 <= 0;
      ns_ff_prev <= 0;
      end
    else begin
      ew_ff1 <= button_EW;
      ew_ff2 <= ew_ff1;
      ew_ff_prev <= ew_ff2;
      
      ns_ff1 <= button_NS;
      ns_ff2 <= ew_ff1;
      ns_ff_prev <= ew_ff2;
      
    end
      
  end
  
  assign EW_pulse = ~ew_ff_prev & ew_ff2;
  assign NS_pulse = ~ns_ff_prev & ns_ff2;
  
  reg req_ew,req_ns;
  
  always@(posedge clk, posedge rst)begin
    if(rst)begin
      req_ew <= 0;
      req_ns <= 0;
    end
    else
      if(EW_pulse) req_ew <= 1'b1;
      if(NS_pulse) req_ns <= 1'b1;
      
      if(state == s3) req_ew <= 1'b0;
      if(state == s0) req_ns <= 1'b0;
  end
  
  always@(posedge clk, posedge rst)begin
     if(rst)begin
       state <= s0;
       duration <= green_d;
       end
       else begin
       state <= next_state;
       duration <= next_duration;
       end
  end
  
  always@(*)begin
     next_state = state;
     next_duration = duration;
      case(state)
         s0 : if(button_EW)begin
                 next_state = s1;
                 next_duration = yellow_d;
                end
              else if(duration != 0)begin
                 next_state = s0;
                 next_duration = duration - 1'b1;
                 end
              else if(duration == 0 && vehicle_overload == 1'b1)begin
                 next_state = s0;
                 next_duration = extra_d;
              end
              else begin
                 next_state = s1;
                 next_duration = yellow_d;
                 end
         s1 : if(duration != 0)begin
                 next_state = s1;
                 next_duration = duration - 1'b1;
                 end
              else begin
                 next_state = s2;
                 next_duration = red_d;
              end
         s2 : if(duration != 0)begin
                  next_state = s2;
                  next_duration = duration - 1'b1; 
              end
              else begin
                  next_state = s3;
                  next_duration = green_d;
              end
         s3 :  if(button_NS)begin
                  next_state = s4;
                  next_duration = yellow_d;
               end
               else if(duration != 0)begin
                  next_state = s3;
                  next_duration = duration - 1'b1;
              end
              else begin
                  next_state = s4;
                  next_duration = yellow_d;
              end
         s4 : if(duration != 0)begin
                  next_state = s4;
                  next_duration = duration - 1'b1;
                  end
              else begin
                  next_state = s0;
                  next_duration = green_d;
              end
         default : begin next_state = s0;
                         next_duration = red_d;
                   end
         endcase
               
  end
  
  always@(*)begin
     case(state)
       s0 : begin output_NS = green;
                  output_EW = red;
            end
       s1 : begin output_NS = yellow;
                  output_EW = red;
            end
       s2 : begin output_NS = red;
                  output_EW = red;
            end
       s3 : begin output_NS = red;
                  output_EW = green;
            end
       s4 : begin output_NS = red;
                  output_EW = yellow;
            end
       default: begin output_NS = yellow;
                      output_EW = yellow;
                end
       endcase
  end
  
endmodule
