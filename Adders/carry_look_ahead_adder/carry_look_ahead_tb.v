`timescale 1ns / 1ps

module carry_look_ahead_tb();
   reg [3:0]A;
   reg [3:0]B;
   reg cin;
   wire [3:0]sum;
   wire cout;
   
   integer pass_count,fail_count;
   
   carry_look_ahead u1(.A(A),.B(B),.cin(cin),.sum(sum),.cout(cout));
   
   task initialize;
     begin
       A = 0;
       B = 0;
       cin = 0;
       pass_count = 0;
       fail_count = 0;
     end
   endtask
   
   task test_cases;
      integer i,j,k;
      reg [3:0]sum_expt;
      reg cout_expt;
      begin
       for(k = 0; k <2; k = k +1)begin
        for(i = 0; i <16;i = i + 1)begin
          for(j = 0; j <16;j = j + 1)begin
             A = i;
             B = j;
             cin = k;
             {cout_expt,sum_expt} = A + B + cin;
             #5;
             check(sum_expt,cout_expt);
             #5;
          end
        end
       end
      end
   endtask
   
   task check(input [3:0]sum_expt,input cout_expt);
     begin
        if({cout,sum} === {cout_expt,sum_expt})begin
           pass_count = pass_count + 1;
           $display("PASS : Sum = %0d, Cout = %0d | sum_expected = %0d | cout_expected = %0b",sum,cout,sum_expt,cout_expt);
        end
        else begin
           fail_count = fail_count + 1;
           $display("FAIL : Sum = %0d, Cout = %0d | sum_expected = %0d | cout_expected = %0b",sum,cout,sum_expt,cout_expt);
        end
     end
   endtask
   initial begin
     $monitor("time = %0d | A = %0d | B = %0d ",$time,A,B);
     
     initialize;
     
     test_cases;
     
     $display("total PASS cases = %0d | FAIL cases = %0d",pass_count,fail_count);
     $finish;
     
   end
endmodule
