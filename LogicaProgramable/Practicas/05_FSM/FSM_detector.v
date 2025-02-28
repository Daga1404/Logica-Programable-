module FSM_detector (
    input MAX10_CLK1_50, rst_a_p,
    input [9:0] SW,
    output [0:6] HEX0,
    output [9:0] LEDR
);
    wire slow_clk;
    wire [3:0] bcd_out;
	 
	 

clk_divider #(.FREQ(2)) SLOW_CLK(
    .clk(MAX10_CLK1_50),
    .rst_a_p(rst_a_p),
    .clk_divider(slow_clk)
);

fsm_detect DETECTOR (
    .clk(slow_clk),
    .rst_a_p(rst_a_p),
    .enable(SW[0]),
    .FSM_out_led(LEDR[0]),
    .FSM_out_BCD(bcd_out)
);

decoder_0_F SM_DECODER (
    .decoder_in(bcd_out),
    .decoder_out(HEX0)
);
endmodule