`timescale 1ns / 1ps

module non_restoring_division #(parameter N = 8)(clk,rst,start,data_in,Quotient,remainder,done,div_by_zero);
    input clk;
    input rst;
    input start;
    input [N-1:0]data_in;
    output [N-1:0]Quotient,remainder;
    output done;
    output div_by_zero;
    
    wire load_divisor,load_dividend,shift_en,correct_en,Done,U_sign,eq,div_zero;
    
    reg divisor_sign,dividend_sign;
    wire [N-1:0]data_in_mag = data_in[N-1]? (~data_in + 1'b1) : data_in;
    
    wire [N-1:0]quotient_unsign, remainder_unsign;
    
    always@(posedge clk or negedge rst)begin
      if(!rst)begin
        dividend_sign <= 1'b0;
        divisor_sign <= 1'b0;
      end
      else begin
        if(load_dividend) dividend_sign <= data_in[N-1];
        if(load_divisor) divisor_sign <= data_in[N-1];
      end
    end
    
    control_unit dut1(.clk(clk),.rst(rst),.U_sign(U_sign),.start(start),.div_zero(div_zero),.load_divisor(load_divisor),.load_dividend(load_dividend),.shift_en(shift_en),.correct_en(correct_en),.Done(done),.eq(eq),.div_by_zero(div_by_zero));
    data_unit #(.N(N)) dut2(.clk(clk),.rst(rst),.load_dividend(load_dividend),.load_divisor(load_divisor),.U_sign(U_sign),.correct_en(correct_en),.data_in(data_in_mag),.shift_en(shift_en),.eq(eq),.quotient(quotient_unsign),.remainder(remainder_unsign),.div_zero(div_zero));
    
    wire quotient_sign  = dividend_sign ^ divisor_sign;
    wire remainder_sign = dividend_sign;
    
    assign Quotient  = quotient_sign  ? (~quotient_unsign  + 1'b1) : quotient_unsign;
    assign remainder = remainder_sign ? (~remainder_unsign + 1'b1) : remainder_unsign;
    
endmodule


module control_unit(clk,rst,U_sign,start,div_zero,load_divisor,load_dividend,shift_en,correct_en,eq,Done,div_by_zero);
    localparam idle = 2'b00, load = 2'b01, execute = 2'b10, done = 2'b11;
    input clk;
    input rst;
    input start;
    input U_sign;
    input eq;
    input div_zero;
    
    output reg correct_en;
    output reg load_divisor;
    output reg load_dividend;
    output reg shift_en;
    output reg Done;
    output reg div_by_zero;
    
    reg [1:0]state,next_state;
    
    always@(posedge clk or negedge rst)begin
       if(!rst)
         state <= idle;
       else 
         state <= next_state;
    end
    
    always@(*)begin
       load_divisor = 1'b0;
       load_dividend = 1'b0;
       shift_en = 1'b0;
       Done = 1'b0;
       correct_en = 1'b0;
       div_by_zero = 1'b0;
       next_state = state;
       
       case(state)
         idle : if(start)begin
                   load_dividend = 1'b1;
                   next_state = load;
                 end
                 else 
                   next_state = idle;
         load :  begin
                   load_divisor = 1'b1;
                   next_state = execute;
                 end
         execute : begin
                     if(div_zero)begin
                         next_state = done;
                     end
                     else if(!eq)begin
                         shift_en = 1'b1;
                         next_state = execute;
                     end
                     else begin
                        if(U_sign)
                           correct_en = 1'b1;
                        next_state = done;
                      end
                   end
         done : begin
                   Done = 1'b1;
                   div_by_zero = div_zero;
                   next_state = idle;
                end 
         default : next_state = idle;
       endcase
    end
endmodule

module data_unit #(parameter N = 8)(clk,rst,load_divisor,load_dividend,correct_en,data_in,shift_en,eq,quotient,remainder,U_sign,div_zero);
   input clk;
   input rst;
   input [N-1:0]data_in;
   input correct_en;
   input load_divisor, load_dividend;
   input shift_en;
   
   output [N-1:0]quotient,remainder;
   output eq;
   output U_sign;
   output div_zero;
   
   parameter width = $clog2(N);
   
   wire [N-1:0]D_out,V_out;
   wire [N:0]U_out;
   wire [N:0]U_shifted;
   wire [N:0]result;
   wire q_in;
   wire [width:0]count;
   wire op_sel;
   
   wire add_sub_control;
   wire [N:0]add_sub_U_in;
   wire U_enable;
   
   assign add_sub_control = (correct_en)? 1'b1 : op_sel;
   assign U_sign = U_out[N];
   assign add_sub_U_in = (correct_en)? U_out : U_shifted;
   assign U_enable = shift_en || correct_en;
   assign div_zero = (D_out == 0);
   
   D_reg #(.N(N)) D_dut(.clk(clk),.rst(rst),.data_in(data_in),.load_divisor(load_divisor),.D_out(D_out));
   V_reg #(.N(N)) V_dut(.clk(clk),.rst(rst),.data_in(data_in),.shift_en(shift_en),.load_dividend(load_dividend),.V_out(V_out),.q_in(q_in));
   U_reg #(.N(N)) U_dut(.clk(clk),.rst(rst),.shift_en(U_enable),.clear(load_divisor),.U_shifted(result),.U_out(U_out));
   add_sub_unit #(.N(N)) add_sub_dut(.U_in(add_sub_U_in),.D_in(D_out),.control(add_sub_control),.result(result));
   shifter #(.N(N)) shifter_dut(.U_in(U_out),.V_in(V_out),.op_sel(op_sel),.U_shifted(U_shifted));
   q_bit #(.N(N)) q_dut(.U_result(result),.q_1(q_in));
   counter #(.N(N)) counter_dut(.clk(clk),.rst(rst),.load(load_dividend),.decrement(shift_en),.count(count));
   
   assign eq = (count == 0);
   assign quotient = (div_zero)? 0 : V_out;
   assign remainder = (div_zero)? 0 : U_out[N-1:0];
   
 
endmodule
module D_reg #(parameter N = 8)(clk,rst,data_in,load_divisor,D_out); // Divisor block
  input clk;
  input rst;
  input [N-1:0]data_in;
  input load_divisor;
  output reg[N-1:0]D_out;
  
  always@(posedge clk or negedge rst)begin
    if(!rst)
      D_out <= {N{1'b0}};
    else if(load_divisor)
      D_out <= data_in;
  end
endmodule
module V_reg #(parameter N = 8)(clk,rst,data_in,shift_en,load_dividend,V_out,q_in); // Dividend block
   input clk;
   input rst;
   input shift_en;
   input q_in;
   input [N-1:0]data_in;
   input load_dividend;
   output reg [N-1:0]V_out;
   
   always@(posedge clk or negedge rst)begin
      if(!rst)
        V_out <= {N{1'b0}};
      else if(load_dividend)
        V_out <= data_in;
      else if(shift_en)
        V_out <= {V_out[N-2:0],q_in};
   end
endmodule
module U_reg #(parameter N= 8)(clk,rst,clear,shift_en,U_shifted,U_out);  //U block 
   input clk;
   input rst;
   input clear;
   input shift_en;
   input [N:0]U_shifted;
   output reg [N:0]U_out;
   
   always@(posedge clk or negedge rst)begin
     if(!rst)
       U_out <= 0;
     else if(clear)
       U_out <= 0;
     else if(shift_en)
       U_out <= U_shifted;
   end
endmodule
module add_sub_unit #(parameter N = 8)(U_in,D_in,control,result); // Add or subtract Unit based on U's last bit 
   input [N:0]U_in;
   input [N-1:0]D_in;
   input control;
   output reg [N:0]result;
   
   wire [N:0]D_new = {1'd0,D_in};
   always@(*)begin
     if(control)
        result = U_in + D_new;
     else
        result = U_in - D_new;
   end
endmodule
module shifter #(parameter N = 8)(U_in,V_in,op_sel,U_shifted);  // the first operation to perform is the shift 
   input [N:0]U_in;
   input [N-1:0]V_in;
   output op_sel;
   output [N:0]U_shifted;
   
   assign U_shifted = {U_in[N:0],V_in[N-1]};
   assign op_sel = U_shifted[N];
endmodule
module q_bit #(parameter N = 8)(U_result,q_1);
   input signed [N:0]U_result;
   output q_1;
   
   assign q_1 = ~U_result[N] ;
endmodule
module counter #(parameter N = 8)(clk,rst,load,decrement,count);
   parameter width = $clog2(N);
   input clk;
   input rst;
   input load;
   input decrement;
   output reg [width:0]count;
   
   always@(posedge clk or negedge rst)begin
      if(!rst)
        count <= {(width+1){1'b0}};
      else if(load)
        count <= N;
      else if(decrement)
        count <= count - 1'b1;
   end
endmodule