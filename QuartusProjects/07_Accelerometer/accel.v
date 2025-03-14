module accel (
   input ADC_CLK_10,
   input MAX10_CLK1_50,
   input MAX10_CLK2_50,

   output [7:0] HEX0,
   output [7:0] HEX1,
   output [7:0] HEX2,
   output [7:0] HEX3,
   output [7:0] HEX4,
   output [7:0] HEX5,

   input [1:0] KEY,

   output [9:0] LEDR,
   output [35:0] GPIO,

   input [9:0] SW,

   output GSENSOR_CS_N,
   input [2:1] GSENSOR_INT,
   output GSENSOR_SCLK,
   inout GSENSOR_SDI,
   inout GSENSOR_SDO

      // Nuevos puertos de salida para acceder a los valores del acelerómetro
   output signed [15:0] data_x_out,
   output signed [15:0] data_y_out,
   output signed [15:0] data_z_out
);

localparam SPI_CLK_FREQ = 200;
localparam UPDATE_FREQ = 1;

wire reset_n = KEY[0];
wire clk, spi_clk, spi_clk_out;
wire data_update;
wire signed [15:0] data_x, data_y, data_z;

PLL ip_inst (
   .inclk0 ( MAX10_CLK1_50 ),
   .c0 ( clk ),
   .c1 ( spi_clk ),
   .c2 ( spi_clk_out )
);

spi_control #(.SPI_CLK_FREQ(SPI_CLK_FREQ), .UPDATE_FREQ(UPDATE_FREQ))
spi_ctrl (
   .reset_n(reset_n), .clk(clk), .spi_clk(spi_clk), .spi_clk_out(spi_clk_out),
   .data_update(data_update),
   .data_x(data_x), .data_y(data_y), .data_z(data_z),
   .SPI_SDI(GSENSOR_SDI), .SPI_SDO(GSENSOR_SDO), .SPI_CSN(GSENSOR_CS_N),
   .SPI_CLK(GSENSOR_SCLK), .interrupt()
);

// Asignación de valores internos a los puertos de salida
assign data_x_out = data_x;
assign data_y_out = data_y;
assign data_z_out = data_z;

reg [31:0] refresh_counter = 0;
reg slow_refresh = 0;

always @(posedge clk) begin
    if(refresh_counter >= 25_000_000) begin
        slow_refresh <= ~slow_refresh;
        refresh_counter <= 0;
    end
    else refresh_counter <= refresh_counter + 1;
end

wire signed [15:0] abs_z = (data_z < 0) ? -data_z : data_z;
wire signed [15:0] abs_x = (data_x < 0) ? -data_x : data_x;
wire signed [15:0] abs_y = (data_y < 0) ? -data_y : data_y;

wire [3:0] unidades_z = abs_z % 10;
wire [3:0] decenas_z = (abs_z / 10) % 10;

wire [3:0] unidades_x = abs_x % 10;
wire [3:0] decenas_x = (abs_x / 10) % 10;

wire [3:0] unidades_y = abs_y % 10;
wire [3:0] decenas_y = (abs_y / 10) % 10;

assign LEDR[9] = (data_z < 0);
assign LEDR[8] = (data_x < 0);
assign LEDR[7] = (data_y < 0);

reg [3:0] disp0_r, disp1_r, disp2_r, disp3_r, disp4_r, disp5_r;

always @(posedge slow_refresh) begin
    disp0_r <= unidades_z;
    disp1_r <= decenas_z;
    disp2_r <= unidades_x;
    disp3_r <= decenas_x;
    disp4_r <= unidades_y;
    disp5_r <= decenas_y;
end

seg7 s0 (.in(disp0_r), .display(HEX0));
seg7 s1 (.in(disp1_r), .display(HEX1));
seg7 s2 (.in(disp2_r), .display(HEX2));
seg7 s3 (.in(disp3_r), .display(HEX3));
seg7 s4 (.in(disp4_r), .display(HEX4));
seg7 s5 (.in(disp5_r), .display(HEX5));

endmodule
