`timescale 1ns / 1ps

module synchronous_tb;
  parameter width = 8, depth = 8;
  reg clk,rst;
  reg [width -1:0]data_in;
  reg wr_enable,rd_enable;
  wire full,empty;
  wire [width-1:0]data_out;
  wire [$clog2(depth+1)-1:0]count1;
  
  integer seed = 10;
  
  Synchronous_FIFO u1(.count1(count1),.clk(clk),.rst(rst),.data_in(data_in),.wr_enable(wr_enable),.rd_enable(rd_enable),.full(full),
                      .empty(empty),.data_out(data_out));
       
                     
    task write_block; begin
         repeat(8) begin
            @(negedge clk);
               wr_enable = 1'b1;
               data_in   = $random;
          end
          @(negedge clk) 
              wr_enable = 1'b0;
          end
       endtask
      
     task read_block; begin
          repeat(8) begin
            @(negedge clk);
               rd_enable = 1'b1;
           end
           @(negedge clk) 
                rd_enable = 1'b0;
           end
     endtask
                     
     task write_read_block; begin
          repeat(10) begin
           @(negedge clk);
              wr_enable = 1'b1;
              rd_enable = 1'b1;
              data_in   = $random;
           end
           @(negedge clk);
               wr_enable = 1'b0;
               rd_enable = 1'b0;
           end
     endtask
                     
     initial begin
        $monitor("t=%0t  we=%b re=%b din=%3d | count=%0d full=%b empty=%b dout=%3d",
                        $time, wr_enable, rd_enable, data_in, count1, full, empty, data_out);
        $dumpfile("fifo.vcd");
        $dumpvars(0, synchronous_tb);
                     
        clk = 0; rst = 1;                     
        wr_enable = 0; rd_enable = 0; data_in = 0;
        @(negedge clk) rst = 0;                 
        @(negedge clk) rst = 1;                 
                     
        write_block();   
       
        read_block();
                     
        write_read_block();
                     
        #50 $finish;
     end
     
     always #5 clk = ~clk;
endmodule
