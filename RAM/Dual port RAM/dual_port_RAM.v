`timescale 1ns / 1ps


module dual_port_RAM(clka,rsta,ena,addra,wra,data_ina,data_outa,clkb,rstb,enb,addrb,wrb,data_inb,data_outb);
   parameter depth = 8;
   parameter width = 8;
   input clka,clkb;
   input rsta,rstb;
   input ena,enb;
   input wra,wrb;
   input [$clog2(depth)-1 : 0]addra,addrb;
   input [width - 1:0]data_ina,data_inb;
   output reg [width - 1:0]data_outa,data_outb;
   
   reg [width - 1:0]mem[0:depth-1];
   
   
   always@(posedge clka or posedge rsta)begin
     if(rsta)
       data_outa <= 0;
     else begin
       if(ena)begin
        if(wra)
          mem[addra] <= data_ina;
        else
          data_outa <= mem[addra];
       end
       else
         data_outa <= data_outa;
     end
   end
   
   always@(posedge clkb or posedge rstb)begin
     if(rstb)
       data_outb <= 0;
     else begin
       if(enb)begin
         if(wrb)
           mem[addrb] <= data_inb;
         else
           data_outb <= mem[addrb];
       end
        else
           data_outb <= data_outb;
     end
   end
endmodule
