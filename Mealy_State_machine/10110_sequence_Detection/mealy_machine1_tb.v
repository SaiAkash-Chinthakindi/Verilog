`timescale 1ns / 1ps

module mealy_machine1_tb();
   reg  clk,rst_n, in;
   wire out;

   mealy_machine1 m1(.in(in), .clk(clk), .rst_n(rst_n), .out(out));

   
   reg [3:0] hist = 0;                              
   wire exp_out = (hist == 4'b1011) && (in == 1'b0);   

   always @(posedge clk or negedge rst_n) begin
     if (!rst_n)        hist <= 0;
     else if (exp_out)  hist <= 0;                      
     else               hist <= {hist[2:0], in};
   end

   
   reg     check_en = 0;
   integer errors = 0, checks = 0, matches = 0;

   always @(negedge clk) 
   if (check_en) begin
     #2;                                             
     checks = checks + 1;
     if (exp_out) matches = matches + 1;
     if (out !== exp_out) begin
       errors = errors + 1;
       $display("ERROR t=%0t in=%b exp=%b got=%b", $time, in, exp_out, out);
     end
   end

 
   task reset;
     begin in = 1'b0; clk = 1'b0; rst_n = 1'b1; end
   endtask

   task initialize;
     begin
       @(negedge clk) rst_n = 1'b0;
       repeat(2) @(negedge clk);
       rst_n = 1'b1;
     end
   endtask

   task randomize_test;
     begin
       repeat(50) @(negedge clk) in = $urandom_range(0,1);
     end
   endtask

   task sequence_test;      
     begin
       @(negedge clk) in = 1'b1;
       @(negedge clk) in = 1'b0;
       @(negedge clk) in = 1'b1;
       @(negedge clk) in = 1'b1;
       @(negedge clk) in = 1'b0;
       @(negedge clk);
     end
   endtask

   
   initial begin
     reset;
     initialize;
     check_en = 1;

     repeat(20) begin
       randomize_test;
       sequence_test;
     end

     if (errors == 0 && matches > 0)
       $display("TEST PASSED: %0d checks, %0d matches", checks, matches);
     else
       $display("TEST FAILED: %0d errors, %0d matches", errors, matches);
     $finish;
   end

   always #10 clk = ~clk;
endmodule