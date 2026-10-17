`timescale 1ns / 1ps

module Synchronous_FIFO1_tb();
   parameter data_width = 8;
   parameter depth = 8;
   
   bit clk;
   bit rst;
   bit wr_en;
   bit rd_en;
   bit [data_width -1:0]data_in;
   logic [data_width -1:0]data_out;
   logic full;
   logic empty;
   
   int pass_count;
   int fail_count;
   
   bit [data_width-1:0]mem[$];
   
   Synchronous_FIFO #(.data_width(data_width),.depth(depth)) u2(.clk(clk),.rst(rst),.data_in(data_in),.wr_en(wr_en),.rd_en(rd_en),.data_out(data_out),.full(full),.empty(empty));
   
   initial begin
      forever #10 clk = ~clk;
   end
   task initialize;
      clk = 1'b0;
      rst = 1'b1;
      wr_en = 1'b0;
      rd_en = 1'b0;
   endtask
   
   task reset;
      @(negedge clk) rst = 1'b0;
      @(negedge clk);
      @(negedge clk) rst = 1'b1;
   endtask
   
   task automatic write_fifo();
     bit [data_width-1:0]write_data;
     @(negedge clk)begin
       if(!full) begin
         write_data = $urandom_range(0,2**data_width-1);
         data_in = write_data;
         wr_en = 1'b1;
         
         @(posedge clk) mem.push_back(write_data);
         #2 wr_en = 1'b0;
       end
       else begin
         wr_en = 1'b0;
         $display("time = %0t the memory is full",$time);
       end
     end
   endtask
   
   task automatic read_fifo();
     bit [data_width-1:0]expected_out;
     @(negedge clk)begin
       if(!empty)begin
         rd_en = 1'b1;
         
         @(posedge clk) expected_out = mem.pop_front();
         #2 check_data(data_out,expected_out);
         rd_en = 1'b0;
       end 
       else begin
        rd_en = 1'b0;
        $display("time = %0t the memory is empty",$time);
       end
     end
   endtask
   
   task write_fifo_full;
      int i;
      bit [data_width-1:0]write_data;
      for(i = 0; i <= depth; i = i + 1)begin
         @(negedge clk) begin
           if(!full) begin
             write_data = $urandom_range(0,2**data_width-1);
             data_in = write_data;
             wr_en = 1'b1;
             @(posedge clk)mem.push_back(write_data);
           end
          else begin
            wr_en = 1'b0;
            $display("time = %0t the memory is full",$time);
          end
         end
        end
       @(negedge clk) wr_en = 1'b0;
       check_bit(full,1'b1);
       check_bit(empty,1'b0);
   endtask
   
   task read_fifo_empty;
      bit [data_width-1:0]expected_read;
      for(int i =0; i < depth; i = i + 1)begin
        @(negedge clk)begin
         if(!empty)begin
           rd_en = 1'b1;
           @(posedge clk);
             expected_read = mem.pop_front();
             #2 check_data(data_out,expected_read);
         end
         else begin
           wr_en = 1'b0;
           $display("time = %0t the memory is empty",$time);
         end
         end
      end
      @(negedge clk) rd_en = 1'b0;
      check_bit(empty, 1'b1);
      check_bit(full,  1'b0);
   endtask
   
   task automatic overflow_test;
       @(negedge clk);
        data_in = $urandom_range(0, 2**data_width-1);
       wr_en   = 1'b1;                        
       @(posedge clk);
       @(negedge clk) wr_en = 1'b0;
       check_bit(full, 1'b1);
   endtask
   
   task automatic underflow_test;
      @(negedge clk) rd_en = 1'b1;           
      @(posedge clk);
      @(negedge clk) rd_en = 1'b0;
      check_bit(empty, 1'b1);
   endtask
      
   task check_data(input logic [data_width-1:0]actual, input logic [data_width-1:0]expected);
      if(actual === expected)begin
        pass_count = pass_count + 1'b1;
        $display("PASS - time = %0d | actual = %0b | expected = %0b",$time,actual,expected);
      end
      else begin
        fail_count = fail_count + 1'b1;
        $display("FAIL - time = %0d | actual = %0b | expected = %0b",$time,actual,expected);
      end
   endtask
   
   task check_bit(input logic actual,input logic expected);
     if(actual === expected)begin
       pass_count = pass_count + 1'b1;
       $display("PASS - time = %0d | actual = %0b | expected = %0b ",$time,actual,expected);
     end
     else begin
       fail_count = fail_count + 1'b1;
       $display("FAIL - time = %0d | actual = %0b | expected = %0b ",$time,actual,expected);
     end
   endtask
   initial begin
      $dumpfile("dump.vcd");
      $dumpvars(0, Synchronous_FIFO1_tb);
      
      initialize;
      reset;
      check_bit(full,1'b0);
      check_bit(empty,1'b1);
      
      write_fifo_full;
      overflow_test;
      read_fifo_empty;
      
      underflow_test;
      write_fifo;
      read_fifo;
      
      repeat(4) write_fifo();
      fork
         repeat(20) write_fifo();
         repeat(20) read_fifo();
      join
      read_fifo_empty();
      
      repeat(4) write_fifo();
      fork
         repeat(10) write_fifo();
         repeat(4) read_fifo();
      join
      read_fifo_empty();
      
      fork
        repeat(4) write_fifo();
        repeat(10) read_fifo();
      join
      read_fifo_empty();
      
      @(negedge clk);
      $display("Pass count = %0d | fail_count = %0d",pass_count,fail_count);
      $finish;
   end
endmodule
