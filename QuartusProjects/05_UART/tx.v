module tx(
    input [7:0] data,
    input send_data,
    input clk,
    input rst,
    output reg serial_out
);

    localparam base_freq      = 50_000_000;
    localparam baudrate       = 115_200;
    localparam counts_per_bit = base_freq / baudrate;

    localparam TX_IDLE   = 0;
    localparam TX_START  = 1;
    localparam TX_DATA   = 2;
    localparam TX_PARITY = 3;
    localparam TX_STOP   = 4;

    reg [2:0] active_state;
    reg [31:0] clock_ctr;
    reg [2:0] d_idx;
    reg [3:0] one_count;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            active_state <= TX_IDLE;
            serial_out   <= 1;
            clock_ctr    <= 0;
            d_idx        <= 0;
            one_count    <= 0;
        end else begin
            case (active_state)
                TX_IDLE: begin
                    serial_out <= 1;
                    if (send_data) begin
                        active_state <= TX_START;
                        clock_ctr    <= 0;
                        d_idx        <= 0;
                        one_count    <= 0;
                    end
                end

                TX_START: begin
                    serial_out <= 0; // Start bit
                    if (clock_ctr < counts_per_bit - 1)
                        clock_ctr <= clock_ctr + 1;
                    else begin
                        clock_ctr   <= 0;
                        active_state <= TX_DATA;
                    end
                end

                TX_DATA: begin
                    serial_out <= data[d_idx];
                    one_count  <= one_count + (data[d_idx] ? 1 : 0);
                    if (clock_ctr < counts_per_bit - 1)
                        clock_ctr <= clock_ctr + 1;
                    else begin
                        clock_ctr <= 0;
                        d_idx <= (d_idx < 7) ? d_idx + 1 : 0;
                        active_state <= (d_idx == 7) ? TX_PARITY : TX_DATA;
                    end
                end

                TX_PARITY: begin
                  
                    serial_out <= (one_count % 2);
                    if (clock_ctr < counts_per_bit - 1)
                        clock_ctr <= clock_ctr + 1;
                    else begin
                        clock_ctr   <= 0;
                        active_state <= TX_STOP;
                    end
                end

                TX_STOP: begin
                    serial_out <= 1; 
                    if (clock_ctr < counts_per_bit - 1)
                        clock_ctr <= clock_ctr + 1;
                    else begin
                        clock_ctr   <= 0;
                        active_state <= TX_IDLE;
                    end
                end

                default: active_state <= TX_IDLE;
            endcase
        end
    end
endmodule