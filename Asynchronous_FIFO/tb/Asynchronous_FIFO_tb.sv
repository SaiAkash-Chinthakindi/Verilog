`timescale 1ns / 1ps

module Asynchronous_FIFO_tb;

    parameter depth = 8;
    parameter data_width = 8;

    logic w_clk, r_clk;
    bit w_en,  r_en;
    logic w_rst, r_rst;
    bit [data_width-1:0]data_in;
    logic [data_width-1:0]data_out;
    logic full, empty;
    
    bit [data_width-1:0] buffer[$];
    
    int pass_count;
    int fail_count;
    
    bit write_done;
    bit read_done;
    
    FIFO_memory #(.depth(depth), .data_width(data_width)) dut(.w_clk(w_clk), .r_clk(r_clk),.w_en(w_en),.r_en(r_en),.w_rst(w_rst), .r_rst(r_rst),
        .data_in(data_in), .data_out(data_out),.full(full),.empty(empty));
        
    
    initial w_clk = 0;
    always #5 w_clk = ~w_clk;
    
    initial r_clk = 0;
    always #7 r_clk = ~r_clk;
    
    initial begin
      w_rst = 0;
      r_rst = 0;
      w_en = 0;
      r_en = 0;
      data_in = 0;
      #20;
      w_rst = 1'b1;
      r_rst = 1'b1;
    end
    
    task automatic write_fifo;
      @(negedge w_clk);
      if (full) begin
        w_en = 1'b0;
      end
      else begin
        data_in = $random;
        buffer.push_back(data_in);
        w_en = 1'b1;
      end
      @(negedge w_clk);
      w_en = 1'b0;
    endtask
    
    task automatic write_till_full;
      int count;
      count = 0;
      while (!full) begin
        write_fifo();
        count++;
      end
      $display("time = %0t, FIFO became full after %0d writes", $time, count);
      check_bit(full, 1'b1);
    endtask
    
    task automatic read_fifo;
        bit [data_width-1:0] expected;
        bit do_rd;
        do_rd = 1'b0;
        @(negedge r_clk);
        if (!empty) begin
          expected = buffer.pop_front();
          r_en   = 1'b1;
          do_rd  = 1'b1;
        end
        else begin
          r_en = 1'b0;
        end
        @(negedge r_clk);
        r_en = 1'b0;
        if (do_rd) check_data(data_out, expected);
      endtask
      
      task automatic read_till_empty;
         int count;
         count = 0;
         while (!empty) begin
            read_fifo();
            count++;
         end
         $display("time = %0t, FIFO became empty after %0d reads", $time, count);
         check_bit(empty, 1'b1);
      endtask
      
    task automatic check_data(input logic [data_width-1:0]actual, input logic [data_width-1:0]expected);
       if(actual === expected) begin
         pass_count = pass_count + 1'b1;
         $display("time = %0t, pass => actual data = %0b, expected data = %0b.",$time,actual,expected);
       end
       else begin
          fail_count = fail_count + 1'b1;
          $display("time = %0t, fail => actual data = %0b, expected data = %0b.",$time,actual,expected);
       end
    endtask
    
    task automatic check_bit(input logic actual, input logic expected);
       if(actual === expected) begin
         pass_count = pass_count + 1'b1;
         $display("time = %0t, pass => actual data = %0b, expected data = %0b.",$time,actual,expected);
       end
       else begin
         fail_count = fail_count + 1'b1;
         $display("time = %0t, fail => actual data = %0b, expected data = %0b.",$time,actual,expected);
       end
    endtask
    
    // write to fifo 
    initial begin
      wait(w_rst == 1'b1);
      @(negedge w_clk);
      check_bit(full,1'b0);
      
      write_till_full;
      
      repeat(20)begin
        repeat($urandom_range(0,2)) @(negedge w_clk);
        write_fifo;
      end
      write_done = 1'b1;
    end 
    
    //read from fifo
    initial begin
        wait (r_rst === 1'b1);
        @(negedge r_clk);
        check_bit(empty, 1'b1);     
    
        wait (full === 1'b1);       
        read_till_empty();        
    
  
        repeat (20) begin
          repeat ($urandom_range(0,2)) @(negedge r_clk);
          read_fifo();
        end
    
        read_done = 1'b1;
      end
      
    initial begin
      wait (write_done && read_done);
      repeat (5) @(negedge r_clk);  
      while (!empty) read_fifo();
      check_bit(empty, 1'b1);
      
      $display("pass count : %0d, fail count : %0d", pass_count, fail_count);
      if (fail_count == 0)
        $display("All test cases passed");
      else
        $display("the fail count is %0d", fail_count);
      
        $finish;
    end
    
endmodule