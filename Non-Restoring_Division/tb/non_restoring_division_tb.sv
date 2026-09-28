`timescale 1ns / 1ps

module non_restoring_division_tb();
    logic clk;
    logic rst;
    logic start;
    logic [7:0]data_in;
    logic [7:0]quotient,remainder;
    logic done;
    logic div_by_zero;
    
    int pass_count,fail_count;
    
    non_restoring_division dut(.clk(clk),.rst(rst),.start(start),.data_in(data_in),.Quotient(quotient),.remainder(remainder),.done(done),
                               .div_by_zero(div_by_zero));
    
    task reset();
       begin
        clk = 1'b0;
        rst = 1'b1;
        start = 1'b0;
        data_in = 8'd0;
          
        @(negedge clk);
        rst = 1'b0;
        @(negedge clk);
        rst = 1'b1;
      end
    endtask
    
    task execute(input [7:0]dividend_in,input [7:0]divisor_in);
      begin
      @(negedge clk) begin 
                        start = 1'b1;
                        //data_in = 8'd35;
                        data_in = dividend_in;
                      end
      @(negedge clk) begin  
                        //data_in = 8'd2;
                        start = 1'b0;
                        data_in = divisor_in;
                     end
      end
    endtask
    
    task compute(input [7:0]dividend, input [7:0]divisor);
       reg signed [7:0]expected_remainder,expected_quotient;
       begin
          expected_remainder =$signed(dividend) % $signed(divisor);
          expected_quotient = $signed(dividend) / $signed(divisor);
       wait(done);
       
       @(negedge clk);
         if(divisor == 8'd0) begin
             if(div_by_zero)begin
                $display("Pass time = %0d, dividend = %0d, divisor = %0d, div_by_zero correctly asserted, output_remainder = %0d, output_quotient = %0d",
                                    $time,$signed(dividend),$signed(divisor),$signed(remainder),$signed(quotient));
                          pass_count++;
             end
             else begin
                 $display("Fail time = %0d, dividend = %0d, divisor = %0d, div_by_zero NOT asserted, output_remainder = %0d, output_quotient = %0d",
                                    $time,$signed(dividend),$signed(divisor),$signed(remainder),$signed(quotient));
                          fail_count++;
             end
         end
         else begin
         if(expected_remainder === $signed(remainder) && expected_quotient === $signed(quotient)) begin
            $display("Pass time = %0d, dividend = %0d, divisor = %0d, expected_remainder = %0d, expected_quotient = %0d, output_remainder = %0d, output_quotient = %0d",$time,$signed(dividend),$signed(divisor),expected_remainder,expected_quotient,$signed(remainder),$signed(quotient));
            pass_count++;
            end
         else begin
            $display("Fail time = %0d, dividend = %0d, divisor = %0d, expected_remainder = %0d, expected_quotient = %0d, output_remainder = %0d, output_quotient = %0d",$time,$signed(dividend),$signed(divisor),expected_remainder,expected_quotient,$signed(remainder),$signed(quotient));
            fail_count++;
          end
         end
       end
    endtask
    
    task run_inputs(input int num);
       int i;
       reg [7:0]dividend,divisor;
       begin
       for(i = 0; i < num; i = i + 1)begin
          dividend = $urandom_range(0,255);
          divisor = $urandom_range(0,255);
          
          execute(dividend,divisor);
          compute(dividend,divisor);
       end
       end
    endtask
    
    task automatic sweep_dividend_neg128;
       int v;
       logic signed [7:0] dividend_val;
       begin
          dividend_val = -128;
          for(v = -128; v <= 127; v = v + 1) begin
             if(v != 0) begin
                @(negedge clk);
                execute(dividend_val, v[7:0]);
                compute(dividend_val, v[7:0]);
             end
          end
       end
    endtask
    
    task automatic sweep_divisor_neg128;
       int d;
       logic signed [7:0] divisor_val;
       begin
          divisor_val = -128;   
          for(d = -128; d <= 127; d = d + 1) begin
             @(negedge clk);
             execute(d[7:0], divisor_val);
             compute(d[7:0], divisor_val);
          end
       end
    endtask
    
    initial begin
       pass_count = 0;
       fail_count = 0;
       reset;
       
       $dumpfile("division.vcd");
       $dumpvars(0, non_restoring_division_tb);
       
       @(negedge clk) 
       run_inputs(50);
       
       @(negedge clk);
       execute(8'd25,8'd0);
       compute(8'd25,8'd0);
       
       @(negedge clk);
       execute(8'd0,8'd0);    // both zero
       compute(8'd0,8'd0);
       
       @(negedge clk);
       execute(8'd0,8'd45);    // both zero
       compute(8'd0,8'd45);
       @(negedge clk);
       
       @(negedge clk);
       execute(-8'sd100, -8'sd128);
       compute(-8'sd100, -8'sd128);
       
       @(negedge clk);
       execute(-8'sd128, 8'sd5);
       compute(-8'sd128, 8'sd5);
       
       @(negedge clk);
       sweep_divisor_neg128();
       sweep_dividend_neg128();
       
       @(negedge clk);
       
       $display(" REGRESSION DONE: %0d passed, %0d failed (of %0d total)",pass_count, fail_count, pass_count+fail_count);
          
       $finish;
    end
    
    always #5 clk = ~clk;
endmodule
