`timescale 1ns/1ps

module clk_divider_tb;

    // Parameters
    parameter CONST_N = 3;
    parameter CLK_PERIOD = 10; // 10 ns clock period (100 MHz clock)

    // Signals
    reg clk;
    reg rst;
    wire clk_div;

    // Instantiate the clk_divider module
    clk_divider #(.CONST_N(CONST_N)) uut (
        .clk(clk),
        .rst(rst),
        .clk_div(clk_div)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #(CLK_PERIOD / 2) clk = ~clk;
    end

    // Test sequence
    initial begin
        // Initialize signals
        rst = 1;
        #(CLK_PERIOD * 2);
        
        // Release reset
        rst = 0;
        #(CLK_PERIOD * 20);

        // Apply reset again
        rst = 1;
        #(CLK_PERIOD * 2);
        rst = 0;
        #(CLK_PERIOD * 20);

        // Finish simulation
        $stop;
    end

    // Monitor signals
    initial begin
        $monitor("Time=%0t | clk=%b | rst=%b | clk_div=%b", $time, clk, rst, clk_div);
    end
    // Dump waveforms for RTL simulation
    initial begin
        $dumpfile("clk_divider_tb.vcd");
        $dumpvars(0, clk_divider_tb);
    end
endmodule