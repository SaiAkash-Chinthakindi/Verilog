`timescale 1ns / 1ps


module Synchronous_FIFO_tb () ;
   parameter data_width = 8, depth = 8;
   
   logic clk;
   logic rst;
   bit wr_en;
   bit rd_en;
   bit [data_width - 1:0]data_in;
   logic [data_width - 1:0]data_out;
   logic full;
   logic empty;
   
   bit [data_width-1:0] buffer[$];
   
   int pass_count;
   int fail_count;
   
   Synchronous_FIFO #(.data_width(data_width),.depth(depth)) u1(.clk(clk),.rst(rst),.data_in(data_in),.wr_en(wr_en),.rd_en(rd_en),.data_out(data_out),.full(full),.empty(empty));
   
   initial clk = 0;
   
   task automatic reset_dut;
     rst = 0;
     wr_en = 0;
     rd_en = 0;
     data_in = 0;
     buffer.delete();
     @(negedge clk) rst = 1'b1;
     @(negedge clk);
   endtask
   
   task automatic write_fifo;
     @(negedge clk)
       if(!full)  begin 
       data_in = $random;
       buffer.push_back(data_in);
       wr_en = 1'b1;
       end
       else begin
       wr_en = 1'b0;
       $display("time = %0t the memory is full",$time);
       end
     @(negedge clk) wr_en = 1'b0;
   endtask
   
   task automatic read_fifo;
       bit [data_width-1:0] expected;
       if(!empty)begin
         expected = buffer.pop_front();
         @(negedge clk) rd_en = 1'b1;
         @(negedge clk) rd_en = 1'b0;
         check_data(data_out,expected);
       end
   endtask
   /*
   task automatic write_read_fifo();
       bit [data_width-1:0] expected;
       bit do_rd;
       
       do_rd = !empty;
       @(negedge clk)begin
       if(!full)begin
         data_in = $random;
         buffer.push_back(data_in);
         wr_en = 1'b1;
       end
       else 
         wr_en = 1'b0;
       if(do_rd)begin
         rd_en = 1'b1;
         expected = buffer.pop_front();
       end
       end
       @(negedge clk)begin
         wr_en = 1'b0;
         if(do_rd)begin
           //buffer.pop_front();
           rd_en = 1'b0;
           check_data(data_out,expected);
         end
       end
   endtask
   */
   task automatic write_and_read();
      bit[data_width-1:0]expected;
      bit do_wr;
      bit do_rd;
      
      do_wr = !full;
      do_rd = !empty;
      fork
        begin
          if(do_wr)begin
            data_in = $random;
            buffer.push_back(data_in);
            @(negedge clk) wr_en = 1'b1;
            @(negedge clk) wr_en = 1'b0;
          end
        end
        begin
          if(do_rd)begin
            //expected = pop_front();
            @(negedge clk)begin rd_en = 1'b1;
                                expected = buffer.pop_front();
                          end
            @(negedge clk) rd_en = 1'b0;
            check_data(data_out,expected);
          end
        end
      join
   endtask
   
   task automatic check_data(input logic[data_width-1:0]actual, input logic[data_width-1:0]expected);
      if(actual === expected)begin
        pass_count = pass_count + 1'b1;
        $display("time = %0t case passed : the actual is %0b, expected is %0b ",$time,actual,expected);
      end
      else begin
        fail_count = fail_count + 1'b1;
        $display("time = %0t cass failed : the actual is %0b, expected is %0b ",$time,actual,expected);
       end
   endtask
   
   task automatic check_bit(input logic actual, input logic expected);
     if(actual === expected)begin
       pass_count = pass_count + 1'b1;
       $display("time = %0t, Pass : acutal = %0b, expected = %0b",$time,actual,expected);
     end
     else begin
       fail_count = fail_count + 1'b1;
       $display("time = %0t, Fail : actual = %0b, expected = %0b",$time,actual,expected);
     end
   endtask
   
   
   initial begin
     // Initialization 
     reset_dut();
     check_bit(full,1'b0);
     check_bit(empty,1'b1);
     // write one item to the fifo
     write_fifo();
     //reading one item from fifo
     read_fifo();
     // writing to FIFO
     for(int i = 0; i <depth; i = i + 1)begin
        write_fifo();
     end
     // reading from the fifo
     for(int i = 0; i<depth; i = i + 1)begin
        read_fifo();
     end
     // perform 5 write operations
     for(int i = 0; i <5; i = i + 1)begin
        write_fifo();
     end
     // perform 4 read operations 
     for(int i = 0; i <4; i = i + 1)begin
        read_fifo();
     end
     // perform write and read together
     for(int i = 0; i <5; i = i + 1)begin
       write_fifo();
       read_fifo();
     end
     // reset 
     reset_dut();
     check_bit(full,1'b0);
     check_bit(empty,1'b1);
     
     //simultaneous read and write operation
     //write_fifo();
     //write_fifo();
     
     for(int i = 0; i < 5; i = i + 1'b1)begin
        write_and_read();
     end
     $display("pass count : %0d, fail count : %0d",pass_count,fail_count);
     if(fail_count == 0)
       $display("All test case passed");
     else
       $display("the fail count is %0d",fail_count);
     
     $finish;
   end
   always #5 clk = ~clk;
endmodule
