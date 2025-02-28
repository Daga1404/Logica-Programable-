`timescale 1ns/1ps

module debouncer_tb ();
    reg clk, pb_in, rst;
    wire pb_out;
	 
    debouncer DUT (
        .clk(clk),
        .pb_in(pb_in),
        .rst(rst),
        .pb_out(pb_out)
    );

always #10 clk = ~clk;
initial 
begin
    clk = 0;
    #100 
    pb_in = 1;
    #100
    pb_in = 0;
    #100
    pb_in = 1;
    #100
    pb_in = 0;
    #100
    pb_in = 1;
    #100    
    pb_in = 0;
end
    
endmodule