module letter_generator(
    input  [7:0] letter_code,   // Código ASCII de la letra a dibujar
    input  [9:0] x,             // Coordenada X actual del VGA
    input  [9:0] y,             // Coordenada Y actual del VGA
    input  [9:0] base_x,        // Posición X de inicio para esta letra
    input  [9:0] base_y,        // Posición Y de inicio para esta letra
    output       pixel          // Salida: 1 si (x,y) pertenece a la letra
);
    // Parámetros internos para el tamaño de la letra
    localparam LETTER_HEIGHT = 200;
    localparam LETTER_WIDTH  = 60;
    localparam LINE_WIDTH    = 20;

    reg pix;
    
    always @(*) begin
        // Por defecto, no se dibuja nada
        pix = 1'b0;
		  case(letter_code)
            // A
            8'h41: if ((x >= base_x) && (x < base_x + LINE_WIDTH) && (y >= base_y) && (y < base_y + LETTER_HEIGHT) ||
                       (x >= base_x + LETTER_WIDTH - LINE_WIDTH) && (x < base_x + LETTER_WIDTH) && (y >= base_y) && (y < base_y + LETTER_HEIGHT) ||
                       (x >= base_x) && (x < base_x + LETTER_WIDTH) && (y >= base_y) && (y < base_y + LINE_WIDTH) ||
                       (x >= base_x + LINE_WIDTH) && (x < base_x + LETTER_WIDTH - LINE_WIDTH) && 
                       (y >= base_y + (LETTER_HEIGHT / 2) - (LINE_WIDTH / 2)) && 
                       (y < base_y + (LETTER_HEIGHT / 2) + (LINE_WIDTH / 2))) 
                pix = 1'b1;

				// Letra B (ASCII 0x42)
				8'h42: begin
					 if (
						  // Barra vertical izquierda
						  ((x >= base_x) && (x < base_x + LINE_WIDTH) && (y >= base_y) && (y < base_y + LETTER_HEIGHT)) ||

						  // Barra horizontal superior
						  ((x >= base_x) && (x < base_x + LETTER_WIDTH) && (y >= base_y) && (y < base_y + LINE_WIDTH)) ||

						  // Barra horizontal central
						  ((x >= base_x) && (x < base_x + LETTER_WIDTH) &&
							(y >= base_y + (LETTER_HEIGHT / 2) - (LINE_WIDTH / 2)) &&
							(y < base_y + (LETTER_HEIGHT / 2) + (LINE_WIDTH / 2))) ||

						  // Barra horizontal inferior
						  ((x >= base_x) && (x < base_x + LETTER_WIDTH) &&
							(y >= base_y + LETTER_HEIGHT - LINE_WIDTH) &&
							(y < base_y + LETTER_HEIGHT)) ||

						  // Barra vertical derecha superior
						  ((x >= base_x + LETTER_WIDTH - LINE_WIDTH) && (x < base_x + LETTER_WIDTH) &&
							(y >= base_y) && (y < base_y + (LETTER_HEIGHT / 2))) ||

						  // Barra vertical derecha inferior
						  ((x >= base_x + LETTER_WIDTH - LINE_WIDTH) && (x < base_x + LETTER_WIDTH) &&
							(y >= base_y + (LETTER_HEIGHT / 2)) && (y < base_y + LETTER_HEIGHT))
						 )
						  pix = 1'b1;
						 end


            // C
            8'h43: if ((x >= base_x) && (x < base_x + LINE_WIDTH) && (y >= base_y) && (y < base_y + LETTER_HEIGHT) ||
                       (x >= base_x) && (x < base_x + LETTER_WIDTH) && (y >= base_y) && (y < base_y + LINE_WIDTH) ||
                       (x >= base_x) && (x < base_x + LETTER_WIDTH) && (y >= base_y + LETTER_HEIGHT - LINE_WIDTH) && 
                       (y < base_y + LETTER_HEIGHT)) 
                pix = 1'b1;

            // D
            8'h44: if ((x >= base_x) && (x < base_x + LINE_WIDTH) && (y >= base_y) && (y < base_y + LETTER_HEIGHT) ||
                       (x >= base_x + LETTER_WIDTH - LINE_WIDTH) && (x < base_x + LETTER_WIDTH) && (y >= base_y) &&
                       (y < base_y + LETTER_HEIGHT) ||
                       (x >= base_x) && (x < base_x + LETTER_WIDTH) && (y >= base_y) && (y < base_y + LINE_WIDTH) ||
                       (x >= base_x) && (x < base_x + LETTER_WIDTH) && (y >= base_y + LETTER_HEIGHT - LINE_WIDTH) &&
                       (y < base_y + LETTER_HEIGHT)) 
                pix = 1'b1;

            // E
            8'h45: if ((x >= base_x) && (x < base_x + LINE_WIDTH) && (y >= base_y) && (y < base_y + LETTER_HEIGHT) ||
                       (x >= base_x) && (x < base_x + LETTER_WIDTH) && (y >= base_y) && (y < base_y + LINE_WIDTH) ||
                       (x >= base_x) && (x < base_x + LETTER_WIDTH) && (y >= base_y + LETTER_HEIGHT - LINE_WIDTH) &&
                       (y < base_y + LETTER_HEIGHT) ||
                       (x >= base_x) && (x < base_x + LETTER_WIDTH) && 
                       (y >= base_y + (LETTER_HEIGHT / 2) - (LINE_WIDTH / 2)) &&
                       (y < base_y + (LETTER_HEIGHT / 2) + (LINE_WIDTH / 2))) 
                pix = 1'b1;

            // F
            8'h46: if ((x >= base_x) && (x < base_x + LINE_WIDTH) && (y >= base_y) && (y < base_y + LETTER_HEIGHT) ||
                       (x >= base_x) && (x < base_x + LETTER_WIDTH) && (y >= base_y) && (y < base_y + LINE_WIDTH) ||
                       (x >= base_x) && (x < base_x + LETTER_WIDTH) && 
                       (y >= base_y + (LETTER_HEIGHT / 2) - (LINE_WIDTH / 2)) &&
                       (y < base_y + (LETTER_HEIGHT / 2) + (LINE_WIDTH / 2))) 
                pix = 1'b1;

				// Letra G (ASCII 0x47)
				8'h47: begin
					 if (
						  // Borde izquierdo
						  ((x >= base_x) && (x < base_x + LINE_WIDTH) && (y >= base_y + LINE_WIDTH) && (y < base_y + LETTER_HEIGHT - LINE_WIDTH)) ||

						  // Parte superior
						  ((x >= base_x + LINE_WIDTH) && (x < base_x + LETTER_WIDTH - LINE_WIDTH) && (y >= base_y) && (y < base_y + LINE_WIDTH)) ||

						  // Parte inferior
						  ((x >= base_x + LINE_WIDTH) && (x < base_x + LETTER_WIDTH) && (y >= base_y + LETTER_HEIGHT - LINE_WIDTH) && (y < base_y + LETTER_HEIGHT)) ||

						  // Lado derecho bajo (abierto arriba)
						  ((x >= base_x + LETTER_WIDTH - LINE_WIDTH) && (x < base_x + LETTER_WIDTH) && (y >= base_y + LETTER_HEIGHT / 2) && (y < base_y + LETTER_HEIGHT)) ||

						  // Línea interna para cerrar la G
						  ((x >= base_x + LETTER_WIDTH / 2) && (x < base_x + LETTER_WIDTH - LINE_WIDTH) &&
							(y >= base_y + LETTER_HEIGHT / 2 - LINE_WIDTH / 2) && (y < base_y + LETTER_HEIGHT / 2 + LINE_WIDTH / 2))
						 )
						  pix = 1'b1;
				end

				// Letra H (ASCII 0x48)
				8'h48: begin
					 if (
						  // Barra izquierda
						  ((x >= base_x) && (x < base_x + LINE_WIDTH) && (y >= base_y) && (y < base_y + LETTER_HEIGHT)) ||

						  // Barra derecha
						  ((x >= base_x + LETTER_WIDTH - LINE_WIDTH) && (x < base_x + LETTER_WIDTH) && (y >= base_y) && (y < base_y + LETTER_HEIGHT)) ||

						  // Barra horizontal central
						  ((x >= base_x) && (x < base_x + LETTER_WIDTH) &&
							(y >= base_y + (LETTER_HEIGHT / 2) - (LINE_WIDTH / 2)) && (y < base_y + (LETTER_HEIGHT / 2) + (LINE_WIDTH / 2)))
						 )
						  pix = 1'b1;
				end

				// Letra I (ASCII 0x49)
				8'h49: begin
					 if (
						  // Barra superior
						  ((x >= base_x) && (x < base_x + LETTER_WIDTH) && (y >= base_y) && (y < base_y + LINE_WIDTH)) ||

						  // Barra inferior
						  ((x >= base_x) && (x < base_x + LETTER_WIDTH) && (y >= base_y + LETTER_HEIGHT - LINE_WIDTH) && (y < base_y + LETTER_HEIGHT)) ||

						  // Barra vertical central
						  ((x >= base_x + (LETTER_WIDTH / 2) - (LINE_WIDTH / 2)) && (x < base_x + (LETTER_WIDTH / 2) + (LINE_WIDTH / 2)) &&
							(y >= base_y) && (y < base_y + LETTER_HEIGHT))
						 )
						  pix = 1'b1;
				end

				// Letra J (ASCII 0x4A)
				8'h4A: begin
					 if (
						  // Barra superior
						  ((x >= base_x) && (x < base_x + LETTER_WIDTH) && (y >= base_y) && (y < base_y + LINE_WIDTH)) ||

						  // Barra vertical derecha
						  ((x >= base_x + LETTER_WIDTH - LINE_WIDTH) && (x < base_x + LETTER_WIDTH) && (y >= base_y) && (y < base_y + LETTER_HEIGHT - LINE_WIDTH)) ||

						  // Curva inferior
						  ((x >= base_x) && (x < base_x + LINE_WIDTH) && (y >= base_y + LETTER_HEIGHT - LINE_WIDTH * 2) && (y < base_y + LETTER_HEIGHT)) ||

						  // Base inferior
						  ((x >= base_x) && (x < base_x + LETTER_WIDTH / 2) && (y >= base_y + LETTER_HEIGHT - LINE_WIDTH) && (y < base_y + LETTER_HEIGHT))
						 )
						  pix = 1'b1;
				end

				// Letra K (ASCII 0x4B)
				8'h4B: begin
					 if (
						  // Barra vertical izquierda
						  ((x >= base_x) && (x < base_x + LINE_WIDTH) &&
						  (y >= base_y) && (y < base_y + LETTER_HEIGHT)) ||

						  // Barra vertical derecha 1 (parte superior)
						  ((x >= base_x + LETTER_WIDTH - LINE_WIDTH) && (x < base_x + LETTER_WIDTH) &&
						  (y >= base_y) && (y < base_y + LETTER_HEIGHT / 2)) || // Parte superior de la barra derecha

						  // Barra vertical derecha 2 (parte inferior)
						  ((x >= base_x + LETTER_WIDTH - LINE_WIDTH) && (x < base_x + LETTER_WIDTH) &&
						  (y >= base_y + LETTER_HEIGHT / 2) && (y < base_y + LETTER_HEIGHT)) || // Parte inferior de la barra derecha

						  // Barra horizontal media (como en la H)
						  ((x >= base_x) && (x < base_x + LETTER_WIDTH) &&
						  (y >= base_y + LETTER_HEIGHT / 2 - LINE_WIDTH / 2) && (y < base_y + LETTER_HEIGHT / 2 + LINE_WIDTH / 2))
					 )
						  pix = 1'b1;
				end





				// Letra L (ASCII 0x4C)
				8'h4C: begin
					 if (
						  // Barra vertical izquierda
						  ((x >= base_x) && (x < base_x + LINE_WIDTH) && (y >= base_y) && (y < base_y + LETTER_HEIGHT)) ||

						  // Barra horizontal inferior
						  ((x >= base_x) && (x < base_x + LETTER_WIDTH) && (y >= base_y + LETTER_HEIGHT - LINE_WIDTH) && (y < base_y + LETTER_HEIGHT))
						 )
						  pix = 1'b1;
				end

            // M (8'h4D): Dos barras verticales laterales y una aproximación a diagonales centrales.
            8'h4D: begin
                if (((x >= base_x) && (x < base_x + LINE_WIDTH)) ||
                    ((x >= base_x + LETTER_WIDTH - LINE_WIDTH) && (x < base_x + LETTER_WIDTH)))
                    pix = 1'b1;
                // Aproximación: una barra vertical central en la mitad superior
                else if ((x >= base_x + (LETTER_WIDTH>>1) - (LINE_WIDTH>>1)) &&
                         (x < base_x + (LETTER_WIDTH>>1) + (LINE_WIDTH>>1)) &&
                         (y >= base_y) && (y < base_y + LETTER_HEIGHT/2))
                    pix = 1'b1;
            end

            // N (8'h4E): Barras verticales laterales y una diagonal conectándolas.
            8'h4E: begin
                if ((x >= base_x) && (x < base_x + LINE_WIDTH) &&
                    (y >= base_y) && (y < base_y + LETTER_HEIGHT))
                    pix = 1'b1;
                else if ((x >= base_x + LETTER_WIDTH - LINE_WIDTH) && (x < base_x + LETTER_WIDTH) &&
                         (y >= base_y) && (y < base_y + LETTER_HEIGHT))
                    pix = 1'b1;
                // Diagonal (aproximada)
                else if (((x - base_x) >= ((y - base_y) * LETTER_WIDTH)/LETTER_HEIGHT) &&
                         ((x - base_x) < ((y - base_y) * LETTER_WIDTH)/LETTER_HEIGHT + LINE_WIDTH))
                    pix = 1'b1;
            end

            // O (8'h4F): Dos barras verticales y dos horizontales (forma rectangular).
            8'h4F: begin
                if ((x >= base_x) && (x < base_x + LINE_WIDTH) &&
                    (y >= base_y) && (y < base_y + LETTER_HEIGHT))
                    pix = 1'b1;
                else if ((x >= base_x + LETTER_WIDTH - LINE_WIDTH) && (x < base_x + LETTER_WIDTH) &&
                         (y >= base_y) && (y < base_y + LETTER_HEIGHT))
                    pix = 1'b1;
                else if ((x >= base_x + LINE_WIDTH) && (x < base_x + LETTER_WIDTH - LINE_WIDTH) &&
                         (y >= base_y) && (y < base_y + LINE_WIDTH))
                    pix = 1'b1;
                else if ((x >= base_x + LINE_WIDTH) && (x < base_x + LETTER_WIDTH - LINE_WIDTH) &&
                         (y >= base_y + LETTER_HEIGHT - LINE_WIDTH) && (y < base_y + LETTER_HEIGHT))
                    pix = 1'b1;
            end

            // P (8'h50): Barra vertical izquierda, barra horizontal superior y barra media; la parte inferior derecha no se dibuja.
            8'h50: begin
                if ((x >= base_x) && (x < base_x + LINE_WIDTH) &&
                    (y >= base_y) && (y < base_y + LETTER_HEIGHT))
                    pix = 1'b1;
                else if ((x >= base_x) && (x < base_x + LETTER_WIDTH) &&
                         (y >= base_y) && (y < base_y + LINE_WIDTH))
                    pix = 1'b1;
                else if ((x >= base_x) && (x < base_x + LETTER_WIDTH) &&
                         (y >= base_y + (LETTER_HEIGHT/2) - (LINE_WIDTH/2)) &&
                         (y < base_y + (LETTER_HEIGHT/2) + (LINE_WIDTH/2)))
                    pix = 1'b1;
                else if ((x >= base_x + LETTER_WIDTH - LINE_WIDTH) && (x < base_x + LETTER_WIDTH) &&
                         (y >= base_y) && (y < base_y + LETTER_HEIGHT/2))
                    pix = 1'b1;
            end

            // Q (8'h51): Igual que O con una “cola” diagonal en la parte inferior derecha.
            8'h51: begin
                if ((x >= base_x) && (x < base_x + LINE_WIDTH) &&
                    (y >= base_y) && (y < base_y + LETTER_HEIGHT))
                    pix = 1'b1;
                else if ((x >= base_x + LETTER_WIDTH - LINE_WIDTH) && (x < base_x + LETTER_WIDTH) &&
                         (y >= base_y) && (y < base_y + LETTER_HEIGHT))
                    pix = 1'b1;
                else if ((x >= base_x + LINE_WIDTH) && (x < base_x + LETTER_WIDTH - LINE_WIDTH) &&
                         (y >= base_y) && (y < base_y + LINE_WIDTH))
                    pix = 1'b1;
                else if ((x >= base_x + LINE_WIDTH) && (x < base_x + LETTER_WIDTH - LINE_WIDTH) &&
                         (y >= base_y + LETTER_HEIGHT - LINE_WIDTH) && (y < base_y + LETTER_HEIGHT))
                    pix = 1'b1;
                // Cola diagonal
                else if ((x >= base_x + LETTER_WIDTH - (LINE_WIDTH*2)) && (x < base_x + LETTER_WIDTH) &&
                         (y >= base_y + LETTER_HEIGHT - (LINE_WIDTH*2)) && (y < base_y + LETTER_HEIGHT - LINE_WIDTH))
                    pix = 1'b1;
            end

            // R (8'h52): Como P, pero con una diagonal en la parte inferior derecha.
            8'h52: begin
                if ((x >= base_x) && (x < base_x + LINE_WIDTH) &&
                    (y >= base_y) && (y < base_y + LETTER_HEIGHT))
                    pix = 1'b1;
                else if ((x >= base_x) && (x < base_x + LETTER_WIDTH) &&
                         (y >= base_y) && (y < base_y + LINE_WIDTH))
                    pix = 1'b1;
                else if ((x >= base_x) && (x < base_x + LETTER_WIDTH) &&
                         (y >= base_y + (LETTER_HEIGHT/2) - (LINE_WIDTH/2)) &&
                         (y < base_y + (LETTER_HEIGHT/2) + (LINE_WIDTH/2)))
                    pix = 1'b1;
                else if ((x >= base_x + LETTER_WIDTH - LINE_WIDTH) && (x < base_x + LETTER_WIDTH) &&
                         (y >= base_y) && (y < base_y + LETTER_HEIGHT/2))
                    pix = 1'b1;
                // Diagonal para la pata
                else if ((y >= base_y + LETTER_HEIGHT/2) &&
                         (x >= base_x) && (x < base_x + LETTER_WIDTH) &&
                         ((x - base_x) < ((y - (base_y + LETTER_HEIGHT/2)) * LETTER_WIDTH)/(LETTER_HEIGHT/2)))
                    pix = 1'b1;
            end

            // S (8'h53): Forma de “S” aproximada con tres barras horizontales y dos verticales parciales.
            8'h53: begin
                if ((x >= base_x) && (x < base_x + LETTER_WIDTH) &&
                    (y >= base_y) && (y < base_y + LINE_WIDTH))
                    pix = 1'b1;
                else if ((x >= base_x) && (x < base_x + LETTER_WIDTH) &&
                         (y >= base_y + (LETTER_HEIGHT/2) - (LINE_WIDTH/2)) &&
                         (y < base_y + (LETTER_HEIGHT/2) + (LINE_WIDTH/2)))
                    pix = 1'b1;
                else if ((x >= base_x) && (x < base_x + LETTER_WIDTH) &&
                         (y >= base_y + LETTER_HEIGHT - LINE_WIDTH) && (y < base_y + LETTER_HEIGHT))
                    pix = 1'b1;
                else if ((x >= base_x) && (x < base_x + LINE_WIDTH) &&
                         (y >= base_y) && (y < base_y + LETTER_HEIGHT/2))
                    pix = 1'b1;
                else if ((x >= base_x + LETTER_WIDTH - LINE_WIDTH) && (x < base_x + LETTER_WIDTH) &&
                         (y >= base_y + LETTER_HEIGHT/2) && (y < base_y + LETTER_HEIGHT))
                    pix = 1'b1;
            end

            // T (8'h54): Barra horizontal superior y barra vertical central.
            8'h54: begin
                if ((x >= base_x) && (x < base_x + LETTER_WIDTH) &&
                    (y >= base_y) && (y < base_y + LINE_WIDTH))
                    pix = 1'b1;
                else if ((x >= base_x + (LETTER_WIDTH>>1) - (LINE_WIDTH>>1)) &&
                         (x < base_x + (LETTER_WIDTH>>1) + (LINE_WIDTH>>1)) &&
                         (y >= base_y) && (y < base_y + LETTER_HEIGHT))
                    pix = 1'b1;
            end

            // U (8'h55): Barras verticales laterales y barra horizontal inferior.
            8'h55: begin
                if (((x >= base_x) && (x < base_x + LINE_WIDTH)) ||
                    ((x >= base_x + LETTER_WIDTH - LINE_WIDTH) && (x < base_x + LETTER_WIDTH)))
                    pix = 1'b1;
                else if ((y >= base_y + LETTER_HEIGHT - LINE_WIDTH) && (y < base_y + LETTER_HEIGHT) &&
                         (x >= base_x) && (x < base_x + LETTER_WIDTH))
                    pix = 1'b1;
            end

            // V (8'h56): Dos diagonales formando una V.
            8'h56: begin
                if ((x >= base_x + (LETTER_WIDTH>>1) - (LINE_WIDTH>>1)) &&
                    (x < base_x + (LETTER_WIDTH>>1) + (LINE_WIDTH>>1)) &&
                    (y >= base_y + LETTER_HEIGHT/2) && (y < base_y + LETTER_HEIGHT))
                    pix = 1'b1;
                else if ((x >= base_x) && (x < base_x + LINE_WIDTH) &&
                         (y >= base_y + LETTER_HEIGHT/2) && (y < base_y + LETTER_HEIGHT))
                    pix = 1'b1;
                else if ((x >= base_x + LETTER_WIDTH - LINE_WIDTH) && (x < base_x + LETTER_WIDTH) &&
                         (y >= base_y + LETTER_HEIGHT/2) && (y < base_y + LETTER_HEIGHT))
                    pix = 1'b1;
            end

            // W (8'h57): Dos barras verticales en los extremos y una aproximación de dos diagonales en el centro.
            8'h57: begin
                if (((x >= base_x) && (x < base_x + LINE_WIDTH)) ||
                    ((x >= base_x + LETTER_WIDTH - LINE_WIDTH) && (x < base_x + LETTER_WIDTH)))
                    pix = 1'b1;
                else if ((x >= base_x + (LETTER_WIDTH>>1) - (LINE_WIDTH>>1)) &&
                         (x < base_x + (LETTER_WIDTH>>1) + (LINE_WIDTH>>1)) &&
                         (y >= base_y + LETTER_HEIGHT/2) && (y < base_y + LETTER_HEIGHT))
                    pix = 1'b1;
            end

            // X (8'h58): Dos diagonales cruzadas.
            8'h58: begin
                if (((x - base_x) >= ((y - base_y) * LETTER_WIDTH)/LETTER_HEIGHT &&
                     (x - base_x) < ((y - base_y) * LETTER_WIDTH)/LETTER_HEIGHT + LINE_WIDTH) ||
                    ((base_x + LETTER_WIDTH - x) >= ((y - base_y) * LETTER_WIDTH)/LETTER_HEIGHT &&
                     (base_x + LETTER_WIDTH - x) < ((y - base_y) * LETTER_WIDTH)/LETTER_HEIGHT + LINE_WIDTH))
                    pix = 1'b1;
            end

            // Y (8'h59): Parte superior en forma de V y barra vertical central inferior.
            8'h59: begin
                if ((x >= base_x + (LETTER_WIDTH>>1) - (LINE_WIDTH>>1)) &&
                    (x < base_x + (LETTER_WIDTH>>1) + (LINE_WIDTH>>1)) &&
                    (y >= base_y + LETTER_HEIGHT/2) && (y < base_y + LETTER_HEIGHT))
                    pix = 1'b1;
                else if ((x >= base_x + (LETTER_WIDTH>>1) - (LINE_WIDTH>>1)) &&
                         (x < base_x + (LETTER_WIDTH>>1) + (LINE_WIDTH>>1)) &&
                         (y >= base_y) && (y < base_y + LETTER_HEIGHT/2))
                    // La parte superior de la V
                    pix = 1'b1;
                else if ((x >= base_x + (LETTER_WIDTH>>1) - (LINE_WIDTH>>1)) &&
                         (x < base_x + (LETTER_WIDTH>>1) + (LINE_WIDTH>>1)) &&
                         (y >= base_y + LETTER_HEIGHT/2) && (y < base_y + LETTER_HEIGHT))
                    // La barra vertical central
                    pix = 1'b1;
            end


            // Z
            8'h5A: if ((x >= base_x) && (x < base_x + LETTER_WIDTH) && (y >= base_y) && (y < base_y + LINE_WIDTH) ||
                       (x >= base_x) && (x < base_x + LETTER_WIDTH) && (y >= base_y + LETTER_HEIGHT - LINE_WIDTH) &&
                       (y < base_y + LETTER_HEIGHT) ||
                       (x >= base_x + (LETTER_WIDTH - LINE_WIDTH) - (y - base_y)) &&
                       (x < base_x + (LETTER_WIDTH - LINE_WIDTH) - (y - base_y) + LINE_WIDTH)) 
                pix = 1'b1;

            default: pix = 1'b0; // Cualquier otro carácter no se dibuja
        endcase
    end

    assign pixel = pix;

endmodule
