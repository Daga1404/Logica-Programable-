`timescale 1ns / 1ps

module FSM_tb;

    // Inputs
    reg clk;
    reg rst_a_p;
    reg enable;

    // Output
    wire FSM_out;

    // Instantiate the FSM module
    FSM uut (
        .clk(clk),
        .rst_a_p(rst_a_p),
        .enable(enable),
        .FSM_out(FSM_out)
    );

    // Clock generation
    always #5 clk = ~clk; // Generate a 10ns period clock (5ns high, 5ns low)

    initial begin
        // Initialize signals
        clk = 0;
        rst_a_p = 1;
        enable = 0;

        // Apply reset
        #10 rst_a_p = 0; // Deassert reset

        // Test sequence
        #10 enable = 1; // Move to state B
        #10 enable = 0; // Move to state C
        #10 enable = 0; // Move to state D
        #10 enable = 1; // Should assert FSM_out
        #10 enable = 0; // Move to state A
        #10 enable = 1; // Move to state B
        #10 enable = 0; // Move to state C
        #10 enable = 1; // Move back to state B
        #10 enable = 0; // Move to state C
        #10 enable = 0; // Move to state D
        #10 enable = 0; // Move to state A

        // Finish simulation
        #20 $stop;
    end

    // Monitor FSM states and output
    initial begin
        $monitor("Time = %0t | clk = %b | rst = %b | enable = %b | FSM_out = %b", 
                 $time, clk, rst_a_p, enable, FSM_out);
    end

endmodule
