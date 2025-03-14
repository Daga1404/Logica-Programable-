module vga (
    input ADC_CLK_10,
    input MAX10_CLK1_50,
    input MAX10_CLK2_50,

    output reg [3:0] VGA_R,
    output reg [3:0] VGA_G,
    output reg [3:0] VGA_B,
    output VGA_HS,
    output VGA_VS,
    
    output [7:0] HEX0,
    output [7:0] HEX1,
    output [7:0] HEX2,
    output [7:0] HEX3,
    output [7:0] HEX4,
    output [7:0] HEX5,

    input [1:0] KEY,

    output [9:0] LEDR,

    input [9:0] SW,
	 
	 input [35:0] GPIO,

    output GSENSOR_CS_N,
    input [2:1] GSENSOR_INT,
    output GSENSOR_SCLK,
    inout GSENSOR_SDI,
    inout GSENSOR_SDO
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

reg [31:0] refresh_counter = 0;
reg slow_refresh = 0;

always @(posedge clk) begin
    if(refresh_counter >= 50_000_000) begin // Actualización cada 2 segundos
        slow_refresh <= ~slow_refresh;
        refresh_counter <= 0;
    end
    else refresh_counter <= refresh_counter + 1;
end

// Conversión de valores absolutos para mostrar
wire signed [15:0] abs_x = (data_x < 0) ? -data_x : data_x;
wire signed [15:0] abs_y = (data_y < 0) ? -data_y : data_y;
wire signed [15:0] abs_z = (data_z < 0) ? -data_z : data_z;

wire [3:0] unidades_x = abs_x % 10;
wire [3:0] decenas_x = (abs_x / 10) % 10;
wire [3:0] unidades_y = abs_y % 10;
wire [3:0] decenas_y = (abs_y / 10) % 10;
wire [3:0] unidades_z = abs_z % 10;
wire [3:0] decenas_z = (abs_z / 10) % 10;

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

// ---------------- VGA Implementation ---------------- //
wire inDisplayArea;
wire [9:0] CounterX, CounterY;
wire clk_25;

clk_divider #(.FREQ(2)) clk_div_inst (
    .clk(MAX10_CLK1_50),
    .rst(0),
    .clk_div(clk_25)
);

hvsync_generator hsync_inst (
    .clk(clk_25),
    .vga_h_sync(VGA_HS),
    .vga_v_sync(VGA_VS),
    .CounterX(CounterX),
    .CounterY(CounterY),
    .inDisplayArea(inDisplayArea)
);

wire pixelX, pixelY, pixelZ;
wire pixelLabelX, pixelLabelY, pixelLabelZ;
wire pixelNumX1, pixelNumX2;
wire pixelNumY1, pixelNumY2;
wire pixelNumZ1, pixelNumZ2;

letter_generator letter_x (
    .letter_code(8'h58), // 'X'
    .x(CounterX),
    .y(CounterY),
    .base_x(50),
    .base_y(50),
    .pixel(pixelLabelX)
);

letter_generator letter_y (
    .letter_code(8'h59), // 'Y'
    .x(CounterX),
    .y(CounterY),
    .base_x(50),
    .base_y(200),
    .pixel(pixelLabelY)
);

letter_generator letter_z (
    .letter_code(8'h5A), // 'Z'
    .x(CounterX),
    .y(CounterY),
    .base_x(50),
    .base_y(350),
    .pixel(pixelLabelZ)
);

number_generator num_x1 (
    .number_code(disp3_r), // Decenas de X
    .x(CounterX),
    .y(CounterY),
    .base_x(200),
    .base_y(50),
    .pixel(pixelNumX1)
);

number_generator num_x2 (
    .number_code(disp2_r), // Unidades de X
    .x(CounterX),
    .y(CounterY),
    .base_x(300),
    .base_y(50),
    .pixel(pixelNumX2)
);

number_generator num_y1 (
    .number_code(disp5_r), // Decenas de Y
    .x(CounterX),
    .y(CounterY),
    .base_x(200),
    .base_y(200),
    .pixel(pixelNumY1)
);

number_generator num_y2 (
    .number_code(disp4_r), // Unidades de Y
    .x(CounterX),
    .y(CounterY),
    .base_x(300),
    .base_y(200),
    .pixel(pixelNumY2)
);

number_generator num_z1 (
    .number_code(disp1_r), // Decenas de Z (corregido)
    .x(CounterX),
    .y(CounterY),
    .base_x(200),  // Ajustar coordenada X
    .base_y(350),  // Ajustar coordenada Y
    .pixel(pixelNumZ1)
);

number_generator num_z2 (
    .number_code(disp0_r), // Unidades de Z (corregido)
    .x(CounterX),
    .y(CounterY),
    .base_x(300),  // Ajustar coordenada X
    .base_y(350),  // Ajustar coordenada Y
    .pixel(pixelNumZ2)
);

wire text_pixel;
assign text_pixel = pixelNumX1 | pixelNumX2 | pixelNumY1 | pixelNumY2 | pixelNumZ1 | pixelNumZ2 | pixelLabelX | pixelLabelY | pixelLabelZ;

always @(posedge clk_25) begin
    if (inDisplayArea && text_pixel) begin
        VGA_R <= 4'b1111;
        VGA_G <= 4'b1111;
        VGA_B <= 4'b1111;
    end else begin
        VGA_R <= 4'b0000;
        VGA_G <= 4'b0000;
        VGA_B <= 4'b0000;
    end
end
assign duty_x = ((data_x + 16'sd32768) * 100) / 16'sd65535;
assign duty_y = ((data_y + 16'sd32768) * 100) / 16'sd65535;
assign duty_z = ((data_z + 16'sd32768) * 100) / 16'sd65535;
// PWM Module Instantiation
PWM PWM_X(
    .clk(MAX10_CLK1_50),
    .enable(1),
    .duty_cycle(duty_x),
    .PWM(GPIO[0])
);

PWM PWM_Y(
    .clk(MAX10_CLK1_50),
    .enable(1),
    .duty_cycle(duty_y),
    .PWM(GPIO[2])
);

PWM PWM_Z(
    .clk(MAX10_CLK1_50),
    .enable(1),
    .duty_cycle(duty_z),
    .PWM(GPIO[4])
);

endmodule