module top_contra (
    input MAX10_CLK1_50,
    input [9:0] SW,
    output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4,
    output [9:0] LEDR
);

    wire slow_clk;

    clk_divider #(.FREQ(50000000)) clk_div_inst (
        .clk(MAX10_CLK1_50),
        .rst(SW[9]),                     
        .clk_div(slow_clk)
    );

    contra fsm_inst (
        .clk(slow_clk),
        .SW(SW),
        .HEX0(HEX0),
        .HEX1(HEX1),
        .HEX2(HEX2),
        .HEX3(HEX3),
        .HEX4(HEX4),
        .LEDR(LEDR)                       // Conecta directamente los 10 LEDs
    );

endmodule
