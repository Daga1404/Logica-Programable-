module FSM_detector (
    input MAX10_CLK1_50, rst_a_p,
    input [9:0] SW,
    output reg [0:6] HEX0,
    output reg [9:0] LEDR
);
    wire slow_clk;
    wire bcd_out;

clk_divider SLOW_CLK #(FREQ = 2)(
    .MAX10_CLK1_50(MAX10_CLK1_50),
    .rst_a_p(rst_a_p),
    .clk_divider(slow_clk)
);

fsm_detect DETECT (
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


