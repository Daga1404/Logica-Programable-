module top_level_counter #(
    parameter IN = 6
)(
    input CLOCK_50,
    output [0:6] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
    output [9:0] LEDR 
);
    wire CLOCK_50_div;
    wire [IN-1:0] count_sec;
    wire [IN-1:0] count_min;
    wire [IN-1:0] count_hour;
    reg sec_reset_reg;
    reg min_reset_reg;

    // Clock Divider Instance
    clk_divider CD (
        .clk(CLOCK_50), 
        .rst(0), 
        .clk_div(CLOCK_50_div)
    );

    // Seconds Counter
    counter SECONDS (
        .clk(CLOCK_50_div),
        .rst(sec_reset_reg), 
        .enable(1), 
        .count(count_sec)
    );

    // BCD Decoder for Seconds Display
    bcd_decoder BD_SECONDS (
        .bcd_in(count_sec), 
        .bcd_out1(HEX0), 
        .bcd_out2(HEX1)
    );

    // Generate a one-cycle pulse for the minute counter enable
    always @(posedge CLOCK_50_div) begin
        if (count_sec == 6'd59)
            sec_reset_reg <= 1;
        else
            sec_reset_reg <= 0;
    end

    // Minutes Counter
    counter MINUTES (
        .clk(CLOCK_50_div),
        .rst(0), 
        .enable(sec_reset_reg),  // Use latched pulse
        .count(count_min)
    );

    // BCD Decoder for Minutes Display
    bcd_decoder BD_MINUTES (
        .bcd_in(count_min), 
        .bcd_out1(HEX2), 
        .bcd_out2(HEX3)
    );

    always @(posedge CLOCK_50_div) begin
        if (count_min == 6'd59)
            min_reset_reg <= 1;
        else
            min_reset_reg <= 0;
    end

    counter HOURS (
        .clk(CLOCK_50_div),
        .rst(0), 
        .enable(min_reset_reg),  // Use latched pulse
        .count(count_hour)
    );

    bcd_decoder BD_HOURS (
        .bcd_in(count_hour), 
        .bcd_out1(HEX4), 
        .bcd_out2(HEX5)
    );



endmodule
