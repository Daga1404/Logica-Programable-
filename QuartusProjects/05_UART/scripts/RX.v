module RX (
    input clk, rst, serial_in,
    output reg [7:0] parallel_out,
    output reg valid_parity
);
    localparam baud_rate = 115_200;
    localparam base_freq = 50_000_000;
    localparam counts_per_bit = base_freq / baud_rate;

    localparam RX_IDLE  = 0;
    localparam RX_START = 1;
    localparam RX_DATA  = 2;
    localparam RX_PARITY = 3;
    localparam RX_STOP  = 4;

    reg [2:0] current_state;
    reg [31:0] clock_ctr = 0;
    reg [7:0] d_idx = 0;
    reg parity_counter;
    reg parity_flag;
    

    always @(posedge clk or negedge rst)
    begin
        if (~rst)
        begin
            current_state <= RX_IDLE;
        end
        else
        begin
            case (current_state)
                RX_IDLE:
                    begin   
                        d_idx <= 0;
                        clock_ctr <= 0;
                        parity_counter <= 0;
                        if (serial_in == 0)
                        begin
                            current_state <= RX_START;
                        end
                        else
                        begin
                            current_state <= RX_IDLE;
                        end
                    end
                RX_START:
                    begin
                        if (clock_ctr <= (counts_per_bit - 1)/2)
                        begin
                            clock_ctr <= clock_ctr + 1;
                            current_state <= RX_START;
                        end
                        else
                        begin
                            current_state <= RX_DATA;
                            clock_ctr <= 0;
                        end
                    end
                RX_DATA:
                    begin
                        if (serial_in == 1)
                        begin
                            parity_counter <= parity_counter + 1;
                        end
                        if (clock_ctr <= counts_per_bit - 1)
                        begin
                            clock_ctr <= clock_ctr + 1;
                            current_state <= RX_DATA;
                        end
                        else
                        begin
                            clock_ctr <= 0;
                            parallel_out[d_idx] <= serial_in;
                            if (d_idx < 7)
                            begin
                                d_idx <= d_idx + 1;
                                current_state <= RX_DATA;
                            end
                            else
                            begin
                                current_state <= RX_PARITY;
                            end
                        end
                    end
                RX_PARITY:
                    begin
                        parity_flag <= parity_counter % 2;
                        if (parity_flag == 0)
                        begin
                            if (clock_ctr < counts_per_bit)
                                begin
                                    clock_ctr <= clock_ctr + 1;
                                    current_state <= RX_PARITY;
                                end
                            else
                                begin
                                    clock_ctr <= 0;
                                    current_state <= RX_STOP;
                                end
                        end
                        else
                        begin
                            current_state <= RX_IDLE;
                        end
                    end
                RX_STOP:
                    begin
                        if (clock_ctr <= counts_per_bit - 1)
                        begin
                            clock_ctr <= clock_ctr + 1;
                            current_state <= RX_STOP;
                        end
                        else
                        begin
                            clock_ctr <= 0;
                            current_state <= RX_IDLE;
                        end
                    end
            endcase
        end
    end
endmodule