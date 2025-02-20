// Code your testbench here
// or browse Examples
`timescale 1ns/100ps

module comb2_tb();
  reg [5:0] d_in;
  wire [2:0] d_out; 

//Instanciamiento del modulo a probar (comb2)

comb2 DUT(
    .data_in(d_in),
    .data_out(d_out)
);
initial 
  begin
    d_in = 6'b101010;
    #10
    $display("Data = %0b , Out = %0b", d_in, d_out);
    #10
    d_in = 6'b101100;
    $display("Data = %0b , Out = %0b", d_in, d_out);
    #10
    d_in = 6'b101101;
    $display("Data = %0b , Out = %0b", d_in, d_out);
    #10
    d_in = 6'b011011;
    $display("Data = %0b , Out = %0b", d_in, d_out);
    #10
    d_in = 6'b101111;
    $display("Data = %0b , Out = %0b", d_in, d_out);
    #10
    d_in = 6'b000111;
    $display("Data = %0b , Out = %0b", d_in, d_out);
    #10
    d_in = 6'b111000;
    $display("Data = %0b , Out = %0b", d_in, d_out);
    #10
   
   $stop;
   $finish;
   
  end
endmodule