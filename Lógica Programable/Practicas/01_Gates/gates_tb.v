// Code your testbench here
// or browse Examples

`timescale 1ns/100ps

module gates_tb();
  reg a_reg;
  reg b_reg;
  wire z_wire;
endmodule

//Instanciar el modulo a probar
//Instancia del modulo gates

gates dut(
  .a_in(a_reg),
  .b_in(b_reg),
  .z_out(z_wire)
);
initial 
  begin
  a_reg = 1'b0;
  b_reg = 1'b0;
    $display("a_in:%0h, b_in%0h, z_wire:%0h", a_reg, b_reg, 				z_wire);
  #10
  a_reg = 1'b0;
  b_reg = 1'b1;
    $display("a_in:%0h, b_in%0h, z_wire:%0h", a_reg, b_reg, 				z_wire);
  #10
  a_reg = 1'b1;
  b_reg = 1'b1;
    $display("a_in:%0h, b_in%0h, z_wire:%0h", a_reg, b_reg, 				z_wire);
  #10
  a_reg = 1'b1;
  b_reg = 1'b0;
    $display("a_in:%0h, b_in%0h, z_wire:%0h", a_reg, b_reg, 				z_wire);
  #10
    $stop;
    $finish;
end
