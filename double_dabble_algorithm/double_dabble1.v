`timescale 1ns / 1ps

module double_dabble1(clk,rst,start,binary_in,Done,bcd_out);
  input clk,rst;
  input start;
  input [7:0]binary_in;
  output Done;
  output [11:0]bcd_out;
  
  wire load,shift,eq;
  
  control_unit u1(.clk(clk),.rst(rst),.start(start),.eq(eq),.load(load),.shift(shift),.Done(Done));
  data_path_unit u2(.clk(clk),.rst(rst),.load(load),.shift(shift),.binary_in(binary_in),.eq(eq),.bcd_out(bcd_out));
endmodule



module control_unit(clk,rst,start,eq,load,shift,Done);
   parameter idle = 2'b00, execute = 2'b01, done = 2'b10;
   input clk;
   input rst;
   input start;
   input eq;
   output reg load;
   output reg shift;
   output reg Done;
   
   reg [1:0]state,next_state;
   
   always@(posedge clk or negedge rst)begin
     if(!rst)begin
        state = idle;
     end
     else 
        state <= next_state;
   end
   
   always@(*)begin
     load = 1'b0;
     shift = 1'b0;
     Done = 1'b0;
     next_state = state;
     
     case(state)
        idle : if(start) begin
                  load = 1'b1;
                  next_state = execute;
               end
        execute : if(eq)begin
                    next_state = done;
                  end
                  else begin
                     next_state = execute;
                     shift = 1'b1;
                  end
        done : begin
                 Done = 1'b1;
                 next_state = idle;
               end
        default: next_state = idle;
     endcase
   end
endmodule


module data_path_unit(clk,rst,load,shift,binary_in,eq,bcd_out);
   input clk;
   input rst;
   input load;
   input shift;
   input [7:0]binary_in;
   output eq;
   output [11:0]bcd_out;
   
   wire [19:0]Dout,corrected,shifted,bus;
   wire [19:0]bin_extend;
   wire [3:0]count;
   
   assign bin_extend = {12'b0,binary_in};
   
   reg_block m1(.binary_out(Dout),.binary_in(bus),.clk(clk),.rst(rst),.load(load | shift));
   compare m2(.bcd_out(corrected),.bcd_in(Dout));
   shift_block m3(.bcd_in(corrected),.shifted(shifted));
   mux_2_1 m4(.out(bus),.in1(bin_extend),.in0(shifted),.sel(load));
   equal m5(.eq(eq),.count(count));
   counts m6(.count(count),.ld(load),.dec(shift),.clk(clk),.rst(rst));
   
   assign bcd_out = Dout[19:8];
      
endmodule

module reg_block(binary_out,binary_in,clk,rst,load);
    input clk;
    input rst;
    input load;
    input [19:0]binary_in;
    output reg [19:0]binary_out;
    
    always@(posedge clk or negedge rst)begin
       if(!rst)
         binary_out <= 0;
       else if(load) 
         binary_out <= binary_in;
    end
endmodule

module compare(bcd_out,bcd_in);
    input [19:0]bcd_in;
    output [19:0]bcd_out;
    
    wire [3:0]ones;
    wire [3:0]tens;
    wire [3:0]hundreds;
    
    assign ones = bcd_in[11:8];
    assign tens = bcd_in[15:12];
    assign hundreds = bcd_in[19:16];
    
    assign bcd_out[7:0] = bcd_in[7:0];
    
    assign bcd_out[11:8] = (ones >= 4'b0101)? ones + 4'b0011 : ones;
    assign bcd_out[15:12] = (tens >= 4'b0101)? tens + 4'b0011 : tens;
    assign bcd_out[19:16] = (hundreds >= 4'b0101)? hundreds + 4'b0011 : hundreds;
    
endmodule

module shift_block(shifted,bcd_in);
   input [19:0]bcd_in;
   output [19:0]shifted;
   
   assign shifted = bcd_in << 1;
endmodule

module mux_2_1(out,in1,in0,sel);
   input sel;
   input [19:0]in1,in0;
   output [19:0]out;
   
   assign out = sel ? in1:in0;
   
endmodule

module equal(eq,count);
   input [3:0]count;
   output eq;
   assign eq = (count == 0);
endmodule

module counts(count,ld,dec,clk,rst);
   input clk;
   input rst;
   input ld;
   input dec;
   output reg [3:0]count;
   
   always@(posedge clk or negedge rst)begin
     if(!rst)
       count <= 0;
     else if(ld)
       count <= 4'b1000;
     else if(dec)
       count <= count - 1'b1;
   end
endmodule