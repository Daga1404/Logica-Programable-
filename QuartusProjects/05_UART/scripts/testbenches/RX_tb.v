`timescale 1ns / 1ps
module RX_tb;
// helper registers/wires
reg rst = 1;
reg clk = 0;
reg serial_data_in = 1;
wire [7:0] rx_data;
// instantiate DUT
RX DUT(
.rst(rst),
.clk(clk),
.serial_in(serial_data_in),
.parallel_out(rx_data)
);
//generate clock signal
always #10 clk <= ~clk; 
parameter clock_period = 20;
parameter baudrate = 'd115_200;
parameter base_clk = 'd50_000_000;
parameter clocks_per_bit = base_clk/baudrate;
parameter c_BIT_PERIOD_NS = clocks_per_bit * clock_period;
// define task for sending serial data
task UART_WRITE_BYTE;
 input [7:0] i_Data;
 integer ii;
 begin
// Send Start Bit
serial_data_in <= 1'b0;
#(c_BIT_PERIOD_NS);
// Send Data Byte
for (ii=0; ii<8; ii=ii+1)
  begin
serial_data_in <= i_Data[ii];
#(c_BIT_PERIOD_NS);
  end
// Send Stop Bit
serial_data_in <= 1'b1;
#(c_BIT_PERIOD_NS);
  end
endtask // UART_WRITE_BYTE
  
initial
begin
rst = 0;
# 1000;
rst = 1;
# 1000;
@(posedge clk);
UART_WRITE_BYTE(8'h37);
@(posedge clk);
# 20;
@(posedge clk);
UART_WRITE_BYTE(8'hFF);
@(posedge clk);
end
endmodule