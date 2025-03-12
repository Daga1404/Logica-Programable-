module Debouncer (
    input clk, pb_in, rst,
    output pb_out
);
 wire Q0, Q1, Q2, Q2_bar;
 wire slow_clk;

 ClockDivider #(.FREQ(40)) u1(
    .clk(clk),
    .rst(rst),
    .clk_div(slow_clk)
 );

    dff d0(
        .clk(slow_clk),
        .d(pb_in),
        .q(Q0)
    );

    dff d1(
        .clk(slow_clk),
        .d(Q0),
        .q(Q1)
    );

    dff d2(
        .clk(slow_clk),
        .d(Q1),
        .q(Q2)
    );

    assign Q2_bar = ~Q2;
    assign pb_out = Q1 & Q2_bar;
endmodule