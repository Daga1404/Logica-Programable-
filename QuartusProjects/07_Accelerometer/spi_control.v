module spi_control#(
        parameter SPI_CLK_FREQ  = 2_000_000,
        parameter UPDATE_FREQ   = 50
    )(
        input reset_n,
        input clk,
        input spi_clk,
        input spi_clk_out,
        output data_update,
        output [15:0] data_x,
        output [15:0] data_y,
        output [15:0] data_z, // eje Z
        output SPI_SDI,
        input SPI_SDO,
        output SPI_CSN,
        output SPI_CLK,
        input [1:0] interrupt
    );

localparam TIMECOUNT = SPI_CLK_FREQ / UPDATE_FREQ;
localparam SDI_WIDTH = 16;
localparam SDO_WIDTH = 8;

localparam WRITE_MODE = 2'b00;
localparam READ_MODE = 2'b10;

localparam INI_NUMBER = 4'd11;

localparam IDLE = 0;
localparam TRANSFER = 1;
localparam INTERACT = 2;

localparam BW_RATE       = 6'h2c;
localparam POWER_CONTROL = 6'h2d;
localparam DATA_FORMAT = 6'h31;

localparam INT_SOURCE = 6'h30;
localparam X_LB = 6'h32;
localparam X_HB = 6'h33;
localparam Y_LB = 6'h34;
localparam Y_HB = 6'h35;
localparam Z_LB = 6'h36;
localparam Z_HB = 6'h37;

reg [3:0] init_index;
reg [SDI_WIDTH-3:0] write_data;
reg [SDI_WIDTH-1:0] data_tx;
reg start;
wire done;
wire [SDO_WIDTH-1:0] data_rx;
reg [1:0] spi_state;

reg data_update_internal;
reg [1:0] data_update_shift;
reg [$clog2(TIMECOUNT)-1:0] sample_count;
wire sample;

reg [2:0] read_index;
reg [7:0] read_command;
localparam LAST_READ_COMMAND = 6;

reg [7:0] data_storage [5:0];

assign data_x = {data_storage[1], data_storage[0]};
assign data_y = {data_storage[3], data_storage[2]};
assign data_z = {data_storage[5], data_storage[4]};

spi_serdes serdes (
    .reset_n(reset_n),
    .spi_clk(spi_clk),
    .spi_clk_out(spi_clk_out),
    .data_tx(data_tx),
    .start(start),
    .done(done),
    .data_rx(data_rx),
    .SPI_SDI(SPI_SDI),
    .SPI_SDO(SPI_SDO),
    .SPI_CSN(SPI_CSN),
    .SPI_CLK(SPI_CLK)
);

always @(*) begin
    case (init_index)
        0: write_data = {BW_RATE, 8'h09};
        1: write_data = {DATA_FORMAT, 8'h00};
        default: write_data = {POWER_CONTROL, 8'h08};
    endcase
end

always @(*) begin
    case (read_index)
        0: read_command = {READ_MODE, X_LB};
        1: read_command = {READ_MODE, X_HB};
        2: read_command = {READ_MODE, Y_LB};
        3: read_command = {READ_MODE, Y_HB};
        4: read_command = {READ_MODE, Z_LB};
        5: read_command = {READ_MODE, Z_HB};
        default: read_command = {READ_MODE, INT_SOURCE};
    endcase
end

assign sample = (sample_count == TIMECOUNT - 1);

always @(posedge spi_clk or negedge reset_n) begin
    if (!reset_n)
        sample_count <= 0;
    else
        sample_count <= sample ? 0 : sample_count + 1'b1;
end

always @(posedge spi_clk or negedge reset_n) begin
    if (!reset_n) begin
        init_index <= 0;
        start <= 0;
        spi_state <= IDLE;
        read_index <= 0;
        data_update_internal <= 0;
    end else if (init_index < INI_NUMBER) begin
        case(spi_state)
            IDLE : begin
                data_tx <= {WRITE_MODE, write_data};
                start <= 1;
                spi_state <= TRANSFER;
            end
            TRANSFER : if (done) begin
                init_index <= init_index + 1;
                start <= 0;
                spi_state <= IDLE;
            end
        endcase
    end else begin
        case(spi_state)
            IDLE : begin
                data_update_internal <= 0;
                read_index <= 0;
                start <= 0;
                if (sample)
                    spi_state <= INTERACT;
            end
            INTERACT : begin
                data_tx[15:8] <= read_command;
                if (read_index > 0)
                    data_storage[read_index - 1] <= data_rx;
                start <= 1;
                spi_state <= TRANSFER;
            end
            TRANSFER : if (done) begin
                start <= 0;
                if (read_index == LAST_READ_COMMAND) begin
                    data_update_internal <= 1;
                    spi_state <= IDLE;
                end else begin
                    read_index <= read_index + 1;
                    spi_state <= INTERACT;
                end
            end
        endcase
    end
end

always @(posedge clk)
    data_update_shift <= {data_update_shift[0], data_update_internal};

assign data_update = data_update_shift == 2'b01;

endmodule
