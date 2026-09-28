`timescale 1ns / 1ps


module booth_algorithm1(clk,rst,data_in,start,Done,product,demo_state);
    input clk;
    input rst;
    input start;
    input [7:0]data_in;
    output Done;
    output [15:0]product;
    output [1:0]demo_state;
    
    wire load_M,load_Q,add_sub,shift_en,op_sel,Q0,Q_1,eq;
    
    control_unit u1(.clk(clk),.rst(rst),.demo_state(demo_state),.start(start),.eq(eq),.load_Q(load_Q),.load_M(load_M),.Q0(Q0),.Q_(Q_1),.shift_en(shift_en),.op_sel(op_sel),.add_sub(add_sub),.Done(Done));
    data_path_unit u2(.clk(clk),.rst(rst),.clear(load_M),.data_in(data_in),.load_Q(load_Q),.load_M(load_M),.shift(shift_en),.add_sub_ctrl(add_sub),.shift_sel(op_sel),.Q0(Q0),.Q_(Q_1),.eq(eq),.product(product));
    
endmodule


module control_unit(clk,rst,start,eq,load_Q,load_M,Q0,Q_,shift_en,op_sel,add_sub,Done,demo_state);
  parameter idle = 2'b00, load =2'b01, execute = 2'b10,done = 2'b11;
  
  input clk;
  input rst;
  input start;
  input eq;
  input Q0,Q_;
  output reg add_sub;
  output reg op_sel;
  output reg load_Q;
  output reg load_M;
  output reg shift_en;
  output reg Done;
  output [1:0]demo_state;
  
  reg [1:0]state,next_state;
  
  assign demo_state = state;
  
  always@(posedge clk or negedge rst)begin
    if(!rst)
      state <= idle;
    else
      state <= next_state;
  end
  
  always@(*)begin
    next_state = state;
    load_Q   = 1'b0;
    load_M   = 1'b0;
    add_sub = 1'b0;
    op_sel  = 1'b0;
    shift_en  = 1'b0;
    Done  = 1'b0;
    
    case(state)
      idle : begin
               if(start)begin 
                 load_M = 1'b1;
                 next_state = load;
               end
             end
      load : begin load_Q = 1'b1;
                   next_state = execute;
             end
      execute : begin
                 if(!eq)begin
                   shift_en = 1'b1;
                   op_sel = Q0 ^ Q_;
                   case({Q0,Q_})
                        2'b00 : begin add_sub = 1'b0; end
                        2'b01 : begin add_sub = 1'b0; end
                        2'b10 : begin add_sub = 1'b1; end
                        2'b11 : begin add_sub = 1'b0; end
                        default : begin add_sub = 1'b0; end
                    endcase
                   next_state = execute;
                  end
                 else if(eq)
                    next_state = done;
                end
       done : begin
                Done = 1'b1;
                next_state = idle;
              end
       default : next_state = idle;
     endcase
      
  end
endmodule


module data_path_unit(clk,rst,data_in,load_Q,load_M,add_sub_ctrl,shift_sel,shift,Q0,Q_,clear,product,eq);
    input clk;
    input rst;
    input load_Q;
    input load_M;
    input clear;
    input add_sub_ctrl;
    input shift_sel;
    input shift;
    input [7:0] data_in;
    
    output Q0;
    output Q_;
    output eq;
    output [15:0]product;
    
    wire [8:0]A_out;
    wire [7:0]Q_out,M_out;
    wire Q1_reg;
    wire [8:0]result;
    wire [8:0]A_shifted;
    wire [7:0]Q_shifted;
    wire Q_1_shifted;
    wire [3:0]count;
    wire [8:0]M_ext;
    
    A_reg A_dut(.clk(clk),.rst(rst),.clear(clear),.shift_en(shift),.shifted_A(A_shifted),.A_out(A_out));
    Q_reg Q_dut(.clk(clk),.rst(rst),.load_Q(load_Q),.data_in(data_in),.shifted_Q(Q_shifted),.shift_en(shift),.Q_out(Q_out));
    M_reg M_dut(.clk(clk),.rst(rst),.load_M(load_M),.data_in(data_in),.M_out(M_out));
    Q_1_reg Q_1_dut(.clk(clk),.rst(rst),.clear(clear),.shift_en(shift),.Q_1_shifted(Q_1_shifted),.Q_bit(Q1_reg));
    add_sub add_sub_dut(.A_in(A_out),.M_in(M_ext),.control(add_sub_ctrl),.result(result));
    counter count_dut(.clk(clk),.rst(rst),.load_count(load_M),.decrement(shift),.count(count));
    shifter shift_dut(.A_in(A_out),.Q_in(Q_out),.Q_(Q1_reg),.result(result),.A_shifted(A_shifted),.Q_shifted(Q_shifted),.Q_bit_shifted(Q_1_shifted),.control(shift_sel));
    
    assign eq = (count == 4'b0000);
    assign product = {A_out[7:0],Q_out};
    assign M_ext = {M_out[7],M_out[7:0]};
    assign Q0 = Q_out[0];
    assign Q_ = Q1_reg;
    
endmodule

module A_reg(clk,rst,clear,shift_en,shifted_A,A_out);
  input clk;
  input rst;
  input clear;
  input shift_en;
  input [8:0]shifted_A;
  output reg[8:0]A_out;
  always@(posedge clk or negedge rst)begin
     if(!rst)
       A_out <= 9'd0;
     else if(clear)
       A_out <= 9'd0;
     else if(shift_en)
       A_out <= shifted_A;
  end
endmodule

module Q_reg(clk,rst,load_Q,data_in,shifted_Q,shift_en,Q_out);
  input clk;
  input rst;
  input load_Q;
  input shift_en;
  input [7:0]data_in;
  input [7:0]shifted_Q;
  output reg [7:0]Q_out;
  
  always@(posedge clk or negedge rst)begin
    if(!rst)
      Q_out <= 0;
    else if(load_Q)
      Q_out <= data_in;
    else if(shift_en)
      Q_out <= shifted_Q;
  end
endmodule

module M_reg(clk,rst,data_in,load_M,M_out);
  input clk;
  input rst;
  input [7:0]data_in;
  input load_M;
  output reg [7:0]M_out;
  
  always@(posedge clk or negedge rst)begin
    if(!rst)
      M_out <= 0;
    else if(load_M)
      M_out <= data_in;
  end
endmodule

module Q_1_reg(clk,rst,shift_en,clear,Q_1_shifted,Q_bit); 
  input clk;
  input rst;
  input clear;
  input shift_en;
  input Q_1_shifted;
  output reg Q_bit;
  
  always@(posedge clk or negedge rst)begin
    if(!rst)
      Q_bit <= 0;
    else if(clear)
      Q_bit <= 0;
    else if(shift_en)
      Q_bit <= Q_1_shifted;
  end
endmodule

module add_sub(A_in,M_in,control,result);
   input [8:0]A_in;
   input [8:0]M_in;
   input control;
   output reg[8:0]result;
   
   always@(*)begin
      if(control)
        result = A_in - M_in;
      else
        result = A_in + M_in;
   end
endmodule

module counter(clk,rst,load_count,decrement,count);
  input clk;
  input rst;
  input load_count;
  input decrement;
  output reg [3:0]count;
  
  always@(posedge clk or negedge rst)begin
     if(!rst)
       count <= 0;
     else if(load_count)
       count <= 4'b1000;
     else if(decrement)
       count <= count - 1'b1;
  end
endmodule

module shifter(A_in,Q_in,Q_,result,control,A_shifted,Q_shifted,Q_bit_shifted);
   input [8:0]A_in;
   input [7:0]Q_in;
   input Q_;
   input [8:0]result;
   input control;
   output [8:0]A_shifted;
   output [7:0]Q_shifted;
   output Q_bit_shifted;
   
   wire [8:0]required;
   wire [17:0]combined;
   wire [17:0]shifted;
   
   assign required = (control == 1'b1)? result : A_in;
   assign combined = {required,Q_in,Q_};
   assign shifted = {combined[17],combined[17:1]};
   assign {A_shifted,Q_shifted,Q_bit_shifted} = shifted;
endmodule