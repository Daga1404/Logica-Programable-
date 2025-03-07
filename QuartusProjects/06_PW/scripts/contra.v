module contra (
    input clk,
    input [9:0] SW,                
    output reg [6:0] HEX0, HEX1, HEX2, HEX3, HEX4,
    output reg [9:0] LEDR
);

    // Estados
    localparam IDLE = 3'b000, DIGIT1 = 3'b001, DIGIT2 = 3'b010, 
               DIGIT3 = 3'b011, DIGIT4 = 3'b100, COMPLETE = 3'b101, ERROR = 3'b110;

    reg [2:0] current_state, next_state;
    reg [9:0] last_sw;

    // Contraseña fija: SW[0], SW[1], SW[2], SW[3]
    reg [3:0] password [3:0];

    initial begin
        password[0] = 4'd0; // SW[0]
        password[1] = 4'd1; // SW[1]
        password[2] = 4'd2; // SW[2]
        password[3] = 4'd3; // SW[3]
    end

    // Detección de flanco positivo
    wire [9:0] sw_rising_edge;
    assign sw_rising_edge = SW & ~last_sw;

    always @(posedge clk) last_sw <= SW;

    // Reset SW[9]
    wire reset = SW[9];

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end
always @(*) begin
    case (current_state)
        IDLE: begin
            if (|sw_rising_edge) begin
                if (sw_rising_edge[password[0]]) 
                    next_state = DIGIT1;
                else
                    next_state = ERROR;         
            end else begin
                next_state = IDLE;
            end
        end

        DIGIT1: begin
            if (sw_rising_edge[password[1]]) 
                next_state = DIGIT2;
            else if (|sw_rising_edge) 
                next_state = ERROR; 
            else 
                next_state = DIGIT1;
        end

        DIGIT2: begin
            if (sw_rising_edge[password[2]]) 
                next_state = DIGIT3;
            else if (|sw_rising_edge) 
                next_state = ERROR;
            else 
                next_state = DIGIT2;
        end

        DIGIT3: begin
            if (sw_rising_edge[password[3]]) 
                next_state = COMPLETE;
            else if (|sw_rising_edge) 
                next_state = ERROR; 
            else 
                next_state = DIGIT3;
        end

        // Una vez completa la contraseña, vuelve a idle
        COMPLETE:
            next_state = IDLE;

        // Después de error, regresa a idle automáticamente
        ERROR:
            next_state = IDLE;

        // Estado de seguridad por si algo falla
        default:
            next_state = IDLE;
    endcase
end


    // Salida a displays
    always @(posedge clk) begin
        case (current_state)
            IDLE: begin
                HEX0 <= 7'b1111111;
                HEX1 <= 7'b1111111;
                HEX2 <= 7'b1111111;
                HEX3 <= 7'b1111111;
                HEX4 <= 7'b1111111;
            end
            COMPLETE: 
				begin // done
                HEX4 = 7'b1111_111;  
                HEX3 = 7'b0100_001;  
                HEX2 = 7'b1000_000;  
                HEX1 = 7'b1001_000; 
                HEX0 = 7'b0000_110;  
            end
            ERROR: 
				begin // error
                HEX4 = 7'b0000_110;  
                HEX3 = 7'b0101_111;  
                HEX2 = 7'b0101_111;  
                HEX1 = 7'b0100_011;  
                HEX0 = 7'b0101_111;  
            end
            default: begin
                HEX0 <= 7'b1111111;
                HEX1 <= 7'b1111111;
                HEX2 <= 7'b1111111;
                HEX3 <= 7'b1111111;
                HEX4 <= 7'b1111111;
            end
        endcase
    end

    // Control de LEDs según progreso de contraseña y reset
    always @(*) begin
        LEDR = 10'b0000000000;  

        case (current_state)
            DIGIT1: LEDR[0] = 1'b1;
            DIGIT2: LEDR[1:0] = 2'b11;
            DIGIT3: LEDR[2:0] = 3'b111;
            DIGIT4: LEDR[3:0] = 4'b1111;
            COMPLETE: LEDR[3:0] = 4'b1111;
            ERROR: LEDR[3:0] = 4'b0000;
            default: LEDR[3:0] = 4'b0000;
        endcase

        LEDR[9] = SW[9];
    end

endmodule

