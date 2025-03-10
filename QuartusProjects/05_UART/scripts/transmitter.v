module TX (
    //Declaracion de puertos de entrada y salida
    input [9:0] SW,
    input MAX10_CLK1_50, rst,
    input [1:0] KEY,
    output reg [35:0] GPIO
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


    wire send = ~KEY[0];
    wire debounced_send;

    debouncer DB1 (
        .clk(MAX10_CLK1_50),
        .rst(rst),
        .pb_in(send),
        .pb_out(debounced_send),
    );

    one_shot OS1 (
        .clk(MAX10_CLK1_50),
        .in_shot(send),
        .one_shot_button(send_pulse)
    );

    //Maquina de estados
    always @(posedge MAX10_CLK1_50 or negedge rst)
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
                            GPIO[0] <= 1;
                            clock_ctr <= 0;
                            d_idx <= 0;
                            parity_counter <= 0;
                            if (send_pulse == 1)
                                current_state <= TX_START;
                            else
                                current_state <= TX_IDLE;
                        end
                    TX_START:
                        begin
                            GPIO[0] <= 0;
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
                            GPIO[0] <= SW[d_idx];
                            if (GPIO[0] == 1)
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
                                    GPIO[0] <= 1;
                                end
                            else    
                                begin
                                    GPIO[0] <= 0;
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
                            GPIO[0] <= 1;
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
