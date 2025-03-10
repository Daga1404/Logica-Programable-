module top_level_counter #(
    parameter IN = 6
)(
    input MAX10_CLK1_50, // Reloj principal
    input [9:0] SW,      // SW[0] = reset, SW[1] = up_down 
    output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5
);

    wire CLOCK_50_div;
    wire [IN-1:0] count_sec;
    wire [IN-1:0] count_min;
    wire [4:0] count_hour; 
    wire debouncer_rst;

    reg tick_min;  
    reg tick_hour; 

    // Debouncer para reset
    debouncer RESET (
        .clk(MAX10_CLK1_50),
        .debouncer_in(SW[0]),
        .rst_a_p(SW[2]),
        .debouncer_out(debouncer_rst)
    );

    clk_divider #(.FREQ(500_000)) CD (
        .clk(MAX10_CLK1_50),
        .rst(debouncer_rst),
        .clk_div(CLOCK_50_div)
    );

    // Contador de segundos
    up_down_counter #(.OUT_WIDTH(6), .MAX_COUNT(59)) SECONDS (
        .clk(CLOCK_50_div),
        .reset(debouncer_rst),
        .up_down(SW[1]),
        .tick(1),  // Segundos siempre cuentan
        .count(count_sec)
    );

    bcd_decoder BD_SECONDS (
        .bcd_in(count_sec),
        .bcd_out1(HEX0),
        .bcd_out2(HEX1)
    );

    always @(posedge CLOCK_50_div or posedge debouncer_rst) begin
        if (debouncer_rst)
            tick_min <= 1'b0;
        else if (SW[1]) begin // Modo UP
            if (count_sec == 59)
                tick_min <= 1'b1;
            else
                tick_min <= 1'b0;
        end
        else begin // Modo DOWN
            if (count_sec == 0)
                tick_min <= 1'b1;
            else
                tick_min <= 1'b0;
        end
    end

    // Contador de minutos
    up_down_counter #(.OUT_WIDTH(6), .MAX_COUNT(59)) MINUTES (
        .clk(CLOCK_50_div),
        .reset(debouncer_rst),
        .up_down(SW[1]),
        .tick(tick_min),
        .count(count_min)
    );

    bcd_decoder BD_MINUTES (
        .bcd_in(count_min),
        .bcd_out1(HEX2),
        .bcd_out2(HEX3)
    );

    always @(posedge CLOCK_50_div or posedge debouncer_rst) begin
        if (debouncer_rst)
            tick_hour <= 1'b0;
        else if (SW[1]) begin // Modo UP
            if (tick_min && count_min == 59)
                tick_hour <= 1'b1;
            else
                tick_hour <= 1'b0;
        end
        else begin // Modo DOWN
            if (tick_min && count_min == 0)
                tick_hour <= 1'b1;
            else
                tick_hour <= 1'b0;
        end
    end

    // Contador de horas (0-23)
    up_down_counter #(.OUT_WIDTH(5), .MAX_COUNT(23)) HOURS (
        .clk(CLOCK_50_div),
        .reset(debouncer_rst),
        .up_down(SW[1]),
        .tick(tick_hour),
        .count(count_hour)
    );

    bcd_decoder BD_HOURS (
        .bcd_in(count_hour),
        .bcd_out1(HEX4),
        .bcd_out2(HEX5)
    );

endmodule