module top_level_PWM (
    input [1:0] KEY,
	 input MAX10_CLK1_50,
	 input [9:0] SW,
    output [35:0] GPIO
);
    wire neg_pb_inc = ~KEY[0];
    wire neg_pb_dec = ~KEY[1];
    wire slow_clk;
    wire debounced_pb_inc, debounced_pb_dec;
	 wire debounced_rst = 0;

    reg [31:0] DC, DC_counter;
    reg pwm_out_reg;

    parameter base_freq = 50_000_000;
    parameter target_freq = 50;
    parameter counts = base_freq / target_freq;
    parameter X = counts / 10;

    /*debouncer RESET(
        .clk(MAX10_CLK1_50),
        .pb_in(SW[0]),
        .rst(1'b0),
        .pb_out(debounced_rst)
    );*/

    clk_divider #(.FREQ(50)) u1(
        .clk(MAX10_CLK1_50),
        .rst(debounced_rst),
        .clk_div(slow_clk)
    );

    debouncer INCREASE(
        .clk(slow_clk),
        .pb_in(neg_pb_inc),
        .rst(debounced_rst),
        .pb_out(debounced_pb_inc)
    );

    debouncer DECREASE(
        .clk(slow_clk),
        .pb_in(neg_pb_dec),
        .rst(debounced_rst),
        .pb_out(debounced_pb_dec)
    );

    always @(posedge slow_clk or negedge debounced_rst)
        begin
            if (!debounced_rst)
                DC <= 0;
            else if (debounced_pb_dec && DC >= X)
                DC <= DC - X;
            else if (debounced_pb_inc && DC <= (counts - X))
                DC <= DC + X;
        end

    always @(posedge MAX10_CLK1_50 or negedge debounced_rst)
        begin
            if (!debounced_rst) begin
                DC_counter <= 0;
                pwm_out_reg <= 0;
            end else begin
                if (DC_counter >= counts - 1)
                    DC_counter <= 0;
                else
                    DC_counter <= DC_counter + 1;

                pwm_out_reg <= (DC_counter < DC) ? 1'b1 : 1'b0;
            end
        end

    assign GPIO[0] = pwm_out_reg;

endmodule
