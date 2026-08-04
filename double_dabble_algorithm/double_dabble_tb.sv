`timescale 1ns / 1ps

module double_dabble_tb ;
   logic clk;
   logic rst;
   logic start;
   logic [7:0] binary_in;
   logic [11:0] bcd_out;
   logic Done;
   
   int errors = 0;
   
   double_dabble1 m1(.clk(clk),.rst(rst),.start(start),.binary_in(binary_in),.Done(Done),.bcd_out(bcd_out));
   
   task test_cases(input bit [7:0]binary_input);
     bit [3:0]exp_hundred,exp_tens,exp_ones;
     
     @(negedge clk) begin binary_in = binary_input; 
                          start = 1'b1;
                    end
     @(negedge clk) start = 1'b0;
     
     wait(Done);
     
     exp_hundred = binary_input /100;
     exp_tens = (binary_input/10) % 10;
     exp_ones = binary_input % 10;
     
     if(bcd_out !== {exp_hundred,exp_tens,exp_ones})begin
         errors = errors + 1;
         $display("time = %0d, binary_in = %0b output = %0b expected = %0b",$time,binary_input,bcd_out,{exp_hundred,exp_tens,exp_ones});
     end
     else begin
         $display("PASS binary_in = %0b, output = %0b expected = %0b",binary_input,bcd_out,{exp_hundred,exp_tens,exp_ones});
     end
     
     @(negedge clk);
   endtask
   
   initial begin
     clk = 1'b0;
     rst = 1'b1;
     
     @(negedge clk) rst = 1'b0;
     @(negedge clk);
     @(negedge clk) rst = 1'b1;
     
     for(int i = 0; i <= 255 ; i = i + 1)begin
        test_cases(i[7:0]);
     end
     
     if(!errors)
       $display("All test casses passed");
     else 
       $display(" %d of the test casses failed",errors );
   end
   
   always #5 clk = ~clk;
endmodule
