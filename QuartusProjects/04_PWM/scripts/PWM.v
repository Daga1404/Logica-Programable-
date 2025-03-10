module PWM (
    input wire clk,       // Reloj base de 50 MHz
    input wire enable,    // Switch directo para habilitar el PWM
    input wire btn_up,    // Botón para incrementar (pull-up)
    input wire btn_down,  // Botón para decrementar (pull-up)
    output reg PWM
);

    // Parámetros para la señal PWM para servo
    parameter PERIOD = 1_000_000;     // 20 ms (50 MHz)
    parameter PULSE_MIN = 25_000;     // Pulso mínimo (por ejemplo, 0.5 ms)
    parameter PULSE_MAX = 125_000;    // Pulso máximo (por ejemplo, 2.5 ms)
    parameter STEP_PERCENT = 20;      // Incremento/decremento en duty cycle por clic

    // Señales debounced y clock lento
    wire btn_up_stable;
    wire btn_down_stable;
    wire slow_clk;

    // Instancia del Debouncer para cada botón
    Debouncer debouncer_inst_up (
        .clk(clk),
        .rst(0),
        .pb_in(btn_up),
        .pb_out(btn_up_stable)
    );

    Debouncer debouncer_inst_down (
        .clk(clk),
        .rst(0),
        .pb_in(btn_down),
        .pb_out(btn_down_stable)
    );

    // Instancia del Clock Divider para generar slow_clk (por ejemplo, 50 Hz)
    ClockDivider clock_divider_inst (
        .clk(clk),
        .rst(0),
        .clk_div(slow_clk)
    );

    // Registro que controla el duty cycle. Se mapea de 25 (mínimo) a 125 (máximo).
    reg [10:0] duty_percent = 25;  // Valor inicial en el mínimo
    reg [19:0] pulse_width = PULSE_MIN;
    reg [19:0] counter = 0;

    // Registros para detectar flanco de bajada en los botones
    reg btn_up_last = 1;
    reg btn_down_last = 1;

    // Control del duty cycle con slow_clk
    // Se actualiza solo cuando enable está activo
    always @(posedge slow_clk) begin
        if (enable) begin
            // Incrementa duty_percent si se detecta flanco de bajada en btn_up
            if (!btn_up_stable && btn_up_last) begin
                if (duty_percent < 125)
                    duty_percent <= duty_percent + STEP_PERCENT;
            end

            // Decrementa duty_percent si se detecta flanco de bajada en btn_down
            if (!btn_down_stable && btn_down_last) begin
                if (duty_percent > 25)
                    duty_percent <= duty_percent - STEP_PERCENT;
            end
        end
        // Actualiza el estado anterior de los botones (siempre)
        btn_up_last <= btn_up_stable;
        btn_down_last <= btn_down_stable;
    end

    // Generación del PWM para el servo usando el reloj base (50 MHz)
    always @(posedge clk) begin
        if (!enable) begin
            PWM <= 0;
            counter <= 0;
        end else begin
            // Calcula el ancho de pulso en función del duty_percent.
            // Cuando duty_percent es 25 → pulse_width = PULSE_MIN,
            // y cuando es 125 → pulse_width = PULSE_MAX.
            pulse_width <= PULSE_MIN + ((PULSE_MAX - PULSE_MIN) * (duty_percent - 25)) / 100;
            
            // Genera la señal PWM
            if (counter < pulse_width)
                PWM <= 1;
            else
                PWM <= 0;

            // Reinicia el contador al final del periodo
            if (counter >= PERIOD - 1)
                counter <= 0;
            else
                counter <= counter + 1;
        end
    end

endmodule



