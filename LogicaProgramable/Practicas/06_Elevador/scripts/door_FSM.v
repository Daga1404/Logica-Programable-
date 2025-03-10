module door_FSM (
    input MAX10_CLK1_50,
    input [1:0] KEY,
    input [9:0] SW,
    output reg [9:0] LEDR,
    output reg closed
);
    parameter IDLE = 0, // Estado inicial, todos los led encendidos
              S1 = 1, // Estado 1, se apagan el led 5 y 4
              S2 = 2, // Estado 2, se apagan el led 6 y 3
              S3 = 3, // Estado 3, se apagan el led 7 y 2
              S4 = 4, // Estado 4, se apagan el led 8 y 1
              S5 = 5, // Estado 5, se apagan el led 9 y 0 (todos los led apagados)
              S6 = 6, // Estado 6, se encienden el led 9 y 0
              S7 = 7, // Estado 7, se encienden el led 8 y 1
              S8 = 8, // Estado 8, se encienden el led 7 y 2
              S9 = 9, // Estado 9, se encienden el led 6 y 3
              CLOSED = 10; // Estado 10, se encienden el led 5 y 4 (todos los led encendidos)
    
    wire slow_clk;
	 
	wire enable = ~KEY[0];
    reg [3:0] current_state;
    reg [3:0] next_state;

    clk_divider #(.FREQ(5)) clk_divider(
        .clk(MAX10_CLK1_50),
        .rst(SW[1]),
        .clk_div(slow_clk)
    );
	 
    always @(posedge slow_clk or posedge SW[1])
    begin
        if(SW[1])
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    always @(current_state or enable)
    begin
        case(current_state)
        IDLE:
            begin
                if(enable == 0)
                    next_state = IDLE;
                else
                    next_state = S1;
            end
        S1:
            begin
                next_state = S2;
            end
        S2:
            begin
                next_state = S3;
            end
        S3:
            begin
                next_state = S4;
            end
        S4:
            begin
                next_state = S5;
            end
        S5:
            begin
                next_state = S6;
            end
        S6:
            begin
                next_state = S7;
            end
        S7:
            begin
                next_state = S8;
            end
        S8:
            begin
                next_state = S9;
            end
        S9:
            begin
                next_state = CLOSED;
            end
        CLOSED:
            begin
                next_state = IDLE;
            end
        default:
            next_state = IDLE;
        endcase
    end

    always @(current_state, enable)
    begin
        case(current_state)
        IDLE:
            begin
                LEDR = 10'b1111111111;
                closed = 0;
            end
        S1:
            begin
                LEDR = 10'b1111001111;
                closed = 0;
            end
        S2:
            begin
                LEDR = 10'b1110000111;
                closed = 0;
            end
        S3:
            begin
                LEDR = 10'b1100000011;
                closed = 0;
            end
        S4:
            begin
                LEDR = 10'b1000000001;
                closed = 0;
            end
        S5:
            begin
                LEDR = 10'b0000000000;
                closed = 0;
            end
        S6:
            begin
                LEDR = 10'b1000000001;
                closed = 0;
            end
        S7:
            begin
                LEDR = 10'b1100000011;
                closed = 0;
            end
        S8:
            begin
                LEDR = 10'b1110000111;
                closed = 0;
            end
        S9:
            begin
                LEDR = 10'b1111001111;
                closed = 0;
            end
        CLOSED:
            begin
                LEDR = 10'b1111111111;
                closed = 1;
            end
        endcase

    end
      
endmodule