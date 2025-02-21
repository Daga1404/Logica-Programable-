module top_level_counter #(
    parameter IN = 4
)(
    input CLOCK_50,
    output [0:6] HEX0, HEX1
    output [9:0] LEDR
);
    wire CLOCK_50_div, CLOCK_50_rst;
    wire [IN-1:0] count_sec;

    reg [IN-1:0] count_reg;
    reg clock_aux; 

    clk_divider CD (
        .clk(CLOCK_50), 
        .rst(0), 
        .clk_div(CLOCK_50_div)
    );
    counter SECONDS (
        .clk(CLOCK_50_div),
        .rst(0), 
        .enable(1), 
        .count(count_sec));
    
    bcd_decoder BD_SECONDS (
        .bcd_in(count_sec), 
        .bcd_out1(HEX0), 
        .bcd_out2(HEX1));

    /*always @(posedge CLOCK_50_div or posedge CLOCK_50_rst)
    begin
        if (CLOCK_50_rst)
        begin
            clock_aux <= 1'b0;
            count_reg <= 0;
        end
        else

        begin
            count_reg <= count_sec;
            if (count_reg >= 60)
                clock_aux <= 1'b1;
            else
                clock_aux <= 1'b0;
        end
    end*/
endmodule