`timescale 1ns / 1ps

module adder_subtractor_circuit_tb;
  reg [3:0]A,B;
  reg mode;
  wire [3:0]sum;
  wire cout;
  
  integer seed = 5;
  adder_subtractor_circuit m1(.A(A),.B(B),.mode(mode),.sum(sum),.cout(cout));
  
  task add_subtract;
    integer A_in,B_in;
    input mode_in;
    
    begin
     A_in = $random(seed);
     B_in = $random(seed);
     
     if(A_in < 0)
       A_in = -A_in;
     if(B_in < 0)
       B_in = -B_in;
       
      A = A_in % 5;
      B = B_in % 5;
     mode = mode_in;
     #10;
    end
    
   endtask
  initial begin
    A = 0;
    B = 0;
    $monitor("Time = %0d, A = %d, B = %d, mode = %0b, sum = %d, cout = %b",$time,A,B,mode,sum,cout);
    
    repeat(5) begin
      add_subtract(0);
    end
    repeat(5)begin
      add_subtract(1);
    end
    #10 $finish;
  end
endmodule
