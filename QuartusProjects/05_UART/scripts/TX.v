module TX (
    //Declaracion de puertos de entrada y salida
    input [0:7] data_in,
    input clk, rst, send_data,
    output reg serial_out
);
    //Declaracion de parametros
    localparam base_freq = 50_000_000;
    localparam baud_rate = 115_200;
    localparam counts_per_bit = base_freq / baud_rate;

    //Declaracion de estados de la maquina de estados
    localparam TX_IDLE = 0;
    localparam TX_START = 1;
    localparam TX_DATA = 2;
    localparam TX_PARITY = 3;
    localparam TX_STOP = 4;
    
    //Declaracion de registros auxiliares
    reg [1:0] current_state;
    reg [31:0] clock_ctr;
    reg [7:0] d_idx;
    reg parity_counter;
    reg parity_flag;

    //Declaracion de wires
    wire debounced_send;

    //Instanciacion del modulo debouncer
    debouncer debounce_in(
        .clk(clk),
        .rst(rst),
        .pb_in(send_data),
        .pb_out(debounced_send)
    );

    one_shot os(
        .clk(clk),
        .rst(rst),
        .pb_in(debounced_send),
        .pb_out(one_shot_debounced_send)
    );

    always @(posedge clk or negedge rst)
        begin
            if (~rst)
            begin
                current_state <= TX_IDLE;
            end
            else
            begin
                case (current_state)
                    TX_IDLE: 
                        begin
                            clock_ctr <= 0;
                            d_idx <= 0;
                            if (one_shot_debounced_send)
                                current_state <= TX_START;
                            else
                                current_state <= TX_IDLE;
                        end
                    TX_START:
                        begin
                            serial_out <= 0;
                            if (clock_ctr < counts_per_bit)
                            begin
                                clock_ctr <= clock_ctr + 1;
                                current_state <= TX_START;
                            end
                            else
                            begin
                                clock_ctr <= 0;
                                current_state <= TX_DATA;
                            end
                        end
                    TX_DATA:
                        begin
                            serial_out <= data_in[d_idx];
                            if (serial_out == 1)
                            begin
                                parity_counter <= parity_counter + 1;
                            end
                            if (clock_ctr < counts_per_bit)
                                begin
                                    clock_ctr <= clock_ctr + 1;
                                    current_state <= TX_DATA;
                                end
                            else
                                begin
                                    clock_ctr <= 0;
                                    if (d_idx < 7)
                                        begin
														  d_idx <= d_idx + 1;
                                            current_state <= TX_DATA;
                                        end
                                    else
                                        current_state <= TX_PARITY;
                                end
                        end
                    TX_PARITY: 
                        begin
                            parity_flag <= parity_counter % 2;
                            if (parity_flag == 1)
                                begin
                                    serial_out <= 1;
                                end
                            else    
                                begin
                                    serial_out <= 0;
                                end
                            if (clock_ctr < counts_per_bit)
                                begin
                                    clock_ctr <= clock_ctr + 1;
                                    current_state <= TX_PARITY;
                                end
                            else
                                begin
                                    clock_ctr <= 0;
                                    current_state <= TX_STOP;
                                end
                        end
                    TX_STOP:
                        begin
                            serial_out <= 1;
                            if (clock_ctr < counts_per_bit)
                                begin
                                    clock_ctr <= clock_ctr + 1;
                                    current_state <= TX_STOP;
                                end
                            else
                                begin
                                    current_state <= TX_IDLE;
                                end
                        end
                endcase
            end
        end

endmodule
