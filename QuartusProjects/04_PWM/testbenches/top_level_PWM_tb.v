`timescale 1ns/1ps

module top_level_PWM_tb();
    reg [1:0] push_buttons;
	 reg clk, rst;
    wire [35:0] pwm_out;

    top_level_PWM uut(
        .KEY(push_buttons),
        .MAX10_CLK1_50(clk),
        .SW(rst),
        .GPIO(pwm_out)
    );

    initial begin
        clk = 0;
        forever #10 clk = ~clk; // 50MHz clock, 20ns period
    end

    initial begin
        rst = 0;
        push_buttons[0] = 1;
        push_buttons[1] = 1;

        #50 rst = 1; // release reset

        // Test incrementing DC
        repeat(5) begin
            #1000 push_buttons[0] = 0;
            #1000 push_buttons[0] = 1;
        end

        // Test decrementing DC
        repeat(3) begin
            #1000 push_buttons[1] = 0;
            #1000 push_buttons[1] = 1;
        end

        #10000;
        $stop;
    end

    initial begin
        $dumpfile("top_level_PWM_tb.vcd");
        $dumpvars(0, top_level_PWM_tb);
    end
endmodule
