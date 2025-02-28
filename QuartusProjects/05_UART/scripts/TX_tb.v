`timescale 1ns/1ps

module TX_tb ();

reg [7:0] data_in = 8'b11010010;
reg send_data = 0;
reg clk = 0;
reg rst = 1;
wire serial_out;

TX DUT(
    .clk(clk),
    .rst(rst),
    .send_data(send_data),
    .data_in(data_in),
    .serial_out(serial_out)
);

always #10 clk <= ~clk;

initial
begin
    rst = 0;
    #5000;
    rst = 1;
    #5000;
    send_data = 1;
end
    
endmodule