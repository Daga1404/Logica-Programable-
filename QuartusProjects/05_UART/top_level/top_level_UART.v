module top_level_UART (
    input MAX10_CLK1_50, // 50 MHz
    input rst,
    input [9:0] SW,
    input [1:0] KEY,
    output [9:0] LEDR,
    output [35:0] GPIO
);

    wire send = ~KEY[0];
    wire debounced_send;
    wire send_pulse;

    debouncer DB1 (
        .clk(MAX10_CLK1_50),
        .rst(rst),
        .pb_in(send),
        .pb_out(debounced_send),
    );

    one_shot OS1 (
        .clk(MAX10_CLK1_50),
        .in_shot(debounced_send),
        .one_shot_button(send_pulse)
    );

    TX TRANSMITTER (
        .data_in(SW[7:0]),
        .clk(MAX10_CLK1_50),
        .rst(rst),
        .send_data(send_pulse),
        .serial_out(GPIO[0])
    );

    RX RECEIVER (
        .clk(MAX10_CLK1_50),
        .rst(rst),
        .serial_in(GPIO[1]),
        .parallel_out(LEDR[7:0]),
        .valid_parity(LEDR[9])
    );
    
endmodule