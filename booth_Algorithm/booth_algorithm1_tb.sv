`timescale 1ns / 1ps

module booth_algorithm1_tb;
   parameter test = 200;
   logic clk;
   logic rst;
   logic start;
   logic [7:0]data_in;
   logic Done;
   logic [15:0]product;
   logic [1:0]demo_state;
   
   booth_algorithm1 dut(.clk(clk),.rst(rst),.start(start),.data_in(data_in),.Done(Done),.product(product),.demo_state(demo_state));
   
   int i;
   int pass_count;
   int fail_count;
   
   always #5 clk = ~clk;
   
   task reset;
     begin
       clk = 1'b0;
       rst = 1'b1;
       start = 1'b0;
       data_in = 1'b0;
       
       @(negedge clk ) rst = 1'b0;
       @(negedge clk);
       @(negedge clk) rst = 1'b1;
      end
   endtask
   
   task automatic execute(input [7:0] multiplicand, input [7:0] multiplier);
     begin
       @(negedge clk)
        begin
          start = 1'b1;
         // data_in = $signed(-128);
          data_in = multiplicand;
        end
       @(negedge clk) 
        begin
          //data_in = $signed(-122);
          data_in = multiplier;
          start = 1'b0;
        end
     end
   endtask
   
   task automatic compute(input [7:0]multiplicand, input [7:0] multiplier);
     reg signed [15:0]expected_result;
     wait(Done);
     @(negedge clk);
      expected_result = $signed(multiplicand) * $signed(multiplier);
      if($signed(product) === expected_result) begin
        pass_count++;
        $display("Time = %0d, Pass: %0d * %0d = %0d, Dut_output = %0d",$time,$signed(multiplicand),$signed(multiplier),expected_result,$signed(product));
      end
      else
        begin
         fail_count++;
         $display("Time = %0d, fail: %0d * %0d = %0d, Dut_output = %0d",$time,$signed(multiplicand),$signed(multiplier),expected_result,$signed(product));
        end
   endtask
   
   task automatic random_tests(input int num);
     reg [7:0] m,q;
     int i;
     begin
     for(i = 0; i < num; i = i + 1)begin
        m = $urandom_range(0,255);
        q = $urandom_range(0,255);
        
        execute(m,q);
        compute(m,q);
     end
     end
   endtask
   
   initial begin
     pass_count = 0;
     fail_count = 0;
     
     reset();
     //execute(data1,data2);
    // compute(data1,data2);
     
     @(negedge clk);
     random_tests(50);
     
     $display(" TEST DONE: %0d passed, %0d failed ", pass_count, fail_count);
     $finish;
   end
   
endmodule

