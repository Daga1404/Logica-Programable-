module sum_FSM (
    input MAX10_CLK1_50,
    input rst,
    input [3:0] SW,
    input [1:0] KEY,
    output [0:6] HEX0, HEX1, HEX2, HEX3
);

    localparam IDLE = 0;
    localparam PLUS = 1;
    localparam EQUALS = 2;
    localparam DONE = 3;

    wire button = ~KEY[0];

    reg [3:0] a = 0;
    reg [3:0] b = 0;
    reg [3:0] c = 0;

    reg [1:0] state, next_state;

    always @(posedge MAX10_CLK1_50 or posedge rst)
    begin
        if (rst)
        begin
            state <= IDLE;
        end
        else
        state <= next_state;
    end

    always @(state or button)
    begin
        case (state)
            IDLE:
                begin
                    if (button)
                    begin
                        next_state = PLUS;
                    end
                    else
                    begin
                        next_state = IDLE;
                    end
                end
            PLUS:
                begin
                    if (button)
                    begin
                        next_state = EQUALS;
                    end
                    else
                    begin
                        next_state = PLUS;
                    end
                end 
            EQUALS:
                begin
                    if (button)
                    next_state = DONE;
                    else
                    next_state = EQUALS;
                end
            DONE:
                begin
                    next_state = IDLE;
                end
            default: next_state = IDLE;
        endcase
    end

    always @(state or button)
    begin
        case (state)
            IDLE:
                begin
						a <= 0;
						b <= 0;
						c <= 0;
                end 
            PLUS:
                begin
                    a <= SW;
                end
            EQUALS:
                begin
                    b <= SW;
                    a+b
                end
            DONE:
                begin
                    a <= 0;
                    b <= 0;
                    c <= 0;
                end 
        endcase
    end



    bcd_decoder D1(
        .SW(c),
        .HEX0(HEX0),
        .HEX1(HEX1),
        .HEX2(HEX2),
        .HEX3(HEX3)
    );
    
endmodule