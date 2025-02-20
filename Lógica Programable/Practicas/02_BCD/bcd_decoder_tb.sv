module bcd_decoder_tb #(parameter N = 10, ITERACIONES = 10)();

    reg [N-1:0] BCD_in;  // BCD_in de tamaño N

    wire [0:6] D1, D2, D3, D4;

    // Instanciación de la unidad bajo prueba (DUT)
    DecodificadorBCD DUT (
        .bcd_in(BCD_in),
        .D_unidad(D1),
        .D_decena(D2),
        .D_centena(D3),
        .D_mil(D4)
    );

    // Tarea para asignar un valor aleatorio a BCD_in
    task set_input();
        begin
            // Genera un valor aleatorio dentro del rango de N bits
            BCD_in = $urandom_range(0, (2**N)-1); 
            $display("Valor a probar = %d", BCD_in);
            #10;  // Tiempo para permitir la propagación de señales
        end
    endtask

    integer i;

    // Bloque inicial para generar las iteraciones de prueba
    initial begin
        for (i = 0; i < ITERACIONES; i = i + 1) begin
            set_input();
        end
        $finish; // Termina la simulación después de las iteraciones
    end

endmodule