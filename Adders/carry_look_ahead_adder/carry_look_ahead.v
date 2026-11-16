`timescale 1ns / 1ps


module carry_look_ahead(A,B,cin,sum,cout);
   input [3:0]A;
   input [3:0]B;
   input cin;
   output [3:0]sum;
   output cout;
   
   wire [4:0]c;
   wire [3:0]p;
   wire [3:0]g;
   
   assign p[0] = A[0] ^ B[0];
   assign p[1] = A[1] ^ B[1];
   assign p[2] = A[2] ^ B[2];
   assign p[3] = A[3] ^ B[3];
   
   assign g[0] = A[0] & B[0];
   assign g[1] = A[1] & B[1];
   assign g[2] = A[2] & B[2];
   assign g[3] = A[3] & B[3];
   
   assign c[0] = cin;
   assign c[1] = g[0] | (p[0] & c[0]);
   assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0]& c[0]);
   assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c[0]);
   assign c[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & c[0]);
   assign cout = c[4];
   
   assign sum[0] = p[0] ^ c[0];
   assign sum[1] = p[1] ^ c[1];
   assign sum[2] = p[2] ^ c[2];
   assign sum[3] = p[3] ^ c[3];
   
   
endmodule
