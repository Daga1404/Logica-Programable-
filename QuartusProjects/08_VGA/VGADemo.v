module VGADemo(
    input  MAX10_CLK1_50,
    output reg [3:0] VGA_R,
    output reg [3:0] VGA_G,
    output reg [3:0] VGA_B,
    output         VGA_HS,
    output         VGA_VS
);
    // Parámetro: palabra de 6 letras (48 bits: 6 x 8 bits)
    // Ejemplo: "HOLA  " (espacios se pueden usar para no dibujar)
    parameter [47:0] WORD = {"D", "A", "N", "T", "E", " "};

    // Parámetros generales para la posición y tamaño de las letras
    localparam X_START       = 65;   // Posición X inicial
    localparam Y_START       = 140;  // Posición Y inicial
    localparam ESPACIO       = 30;   // Espacio entre letras
    localparam LETTER_HEIGHT = 200;  // Alto de las letras
    localparam LETTER_WIDTH  = 60;   // Ancho de las letras

    // Cálculo de posiciones base para cada letra (índices 0 a 5)
    localparam BASE0 = X_START;
    localparam BASE1 = BASE0 + LETTER_WIDTH + ESPACIO;
    localparam BASE2 = BASE1 + LETTER_WIDTH + ESPACIO;
    localparam BASE3 = BASE2 + LETTER_WIDTH + ESPACIO;
    localparam BASE4 = BASE3 + LETTER_WIDTH + ESPACIO;
    localparam BASE5 = BASE4 + LETTER_WIDTH + ESPACIO;

    // Señales de sincronización y contadores de píxeles (asumiendo que tienes estos módulos implementados)
    wire inDisplayArea;
    wire [9:0] CounterX;
    wire [9:0] CounterY;
    wire clk_25;

    clk_divider #(.DIVISOR(2)) clk_div_inst (
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

    // Señales de píxel para cada letra
    wire pixel0, pixel1, pixel2, pixel3, pixel4, pixel5;

    // Instanciación del módulo letter_generator para cada letra
    // Se extrae el carácter correspondiente del parámetro WORD (8 bits por letra)
    letter_generator letter0 (
        .letter_code(WORD[47:40]),
        .x(CounterX),
        .y(CounterY),
        .base_x(BASE0),
        .base_y(Y_START),
        .pixel(pixel0)
    );

    letter_generator letter1 (
        .letter_code(WORD[39:32]),
        .x(CounterX),
        .y(CounterY),
        .base_x(BASE1),
        .base_y(Y_START),
        .pixel(pixel1)
    );

    letter_generator letter2 (
        .letter_code(WORD[31:24]),
        .x(CounterX),
        .y(CounterY),
        .base_x(BASE2),
        .base_y(Y_START),
        .pixel(pixel2)
    );

    letter_generator letter3 (
        .letter_code(WORD[23:16]),
        .x(CounterX),
        .y(CounterY),
        .base_x(BASE3),
        .base_y(Y_START),
        .pixel(pixel3)
    );

    letter_generator letter4 (
        .letter_code(WORD[15:8]),
        .x(CounterX),
        .y(CounterY),
        .base_x(BASE4),
        .base_y(Y_START),
        .pixel(pixel4)
    );

    letter_generator letter5 (
        .letter_code(WORD[7:0]),
        .x(CounterX),
        .y(CounterY),
        .base_x(BASE5),
        .base_y(Y_START),
        .pixel(pixel5)
    );

    // Combina las señales de cada letra: si alguna se activa, se dibuja la letra.
    wire word_pixel;
    assign word_pixel = pixel0 | pixel1 | pixel2 | pixel3 | pixel4 | pixel5;

    // Generación de color: si estamos en el área de visualización y el píxel pertenece a alguna letra, se dibuja en rojo.
    always @(posedge clk_25) begin
        if (inDisplayArea && word_pixel) begin
            VGA_R <= 4'b1111;
            VGA_G <= 4'b0000;
            VGA_B <= 4'b0000;
        end else begin
            VGA_R <= 4'b0000;
            VGA_G <= 4'b0000;
            VGA_B <= 4'b0000;
        end
    end

endmodule
