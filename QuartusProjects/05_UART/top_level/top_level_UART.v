// Receptor
module uart #(
        parameter INVERT_RST = 1, 
                INVERT_SEND_DATA = 1,
                DEBOUNCE_THRESHOLD = 5000, 
                BASE_FREQ = 50_000_000, 
                BAUDRATE = 115_200,
                DATA_BITS = 8,
                CLOCK_CTR_WIDTH = 32,
                WIRE_SIZE = 4, 
                SEGMENTOS = 7
    )(
    input clk, rst,
	input [1:0] parity_type, // 0: Sin paridad, 1: Paridad impar, 2: Paridad par
    // Transmitter
    input [DATA_BITS-1:0] data,
    input send_data, 
    output serial_out,//tx

    // Receiver
	input serial_data_in,

    output reg [9:0] leds,
    output [0: SEGMENTOS - 1] D_decenas, D_unidades, D_centenas, D_millares, D_decenas_millares, D_centenas_millares
);

wire one_shot_rst, one_shot_send_data;

// Receiver
wire [DATA_BITS-1:0] parallel_out;
wire parity_error;

localparam COUNTS_PER_BIT = BASE_FREQ / BAUDRATE;

debouncer_one_shot #(.INVERT_LOGIC(INVERT_RST), .DEBOUNCE_THRESHOLD(DEBOUNCE_THRESHOLD)) DEB_ONE_SHOT_RST (
    .clk(clk),
    .signal(rst),
    .signal_one_shot(one_shot_rst)
);

debouncer_one_shot #(.INVERT_LOGIC(INVERT_SEND_DATA), .DEBOUNCE_THRESHOLD(DEBOUNCE_THRESHOLD)) DEB_ONE_SHOT_SEND_DATA (
    .clk(clk),
    .signal(send_data),
    .signal_one_shot(one_shot_send_data)
);

always @(posedge clk or posedge one_shot_rst) begin
    if (one_shot_rst)
        begin
            leds <= 10'b0000000000;
            leds[0] <= 1'b1;
            leds[1] <= 1'b0;
        end
    else if (one_shot_send_data == 1)
        begin
            leds[0] <= 1'b0;
            leds[1] <= 1'b1;
        end
    else if (parity_type == 1)
        begin
            leds[8] <= 1'b1;
            leds[9] <= 1'b0;
        end
    else if (parity_type == 2)
        begin
            leds[8] <= 1'b0;
            leds[9] <= 1'b1;
        end     
end

transmitter #(.COUNTS_PER_BIT(COUNTS_PER_BIT), .DATA_BITS(DATA_BITS), .CLOCK_CTR_WIDTH(CLOCK_CTR_WIDTH)) UART_TX(
	.data(data),
	.send_data(one_shot_send_data),
	.clk(clk),
	.rst(one_shot_rst),
	.parity_type(parity_type), // 0: Sin paridad, 1: Paridad impar, 2: Paridad par
	.serial_out(serial_out)
);

receiver #(.COUNTS_PER_BIT(COUNTS_PER_BIT), .DATA_BITS(DATA_BITS), .CLOCK_CTR_WIDTH(CLOCK_CTR_WIDTH)) UART_RX (
    .serial_data_in(serial_out),
	.clk(clk),
	.rst(one_shot_rst),
	.parity_type(parity_type), // 0: Sin paridad, 1: Paridad impar, 2: Paridad par
	.parity_error(parity_error),
	.parallel_out(parallel_out)
);

display_module #(.WIRE_SIZE(WIRE_SIZE), .SEGMENTOS(SEGMENTOS), .BIT_SIZE(DATA_BITS))  DISPLAY_MODULE (
    .number(parallel_out),
    .D_unidades(D_unidades),
    .D_decenas(D_decenas),
    .D_centenas(D_centenas),
    .D_millares(D_millares),
    .D_decenas_millares(D_decenas_millares),
    .D_centenas_millares(D_centenas_millares)
);

endmodule