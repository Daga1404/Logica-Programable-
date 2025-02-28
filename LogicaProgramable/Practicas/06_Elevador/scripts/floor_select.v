 module floor_select (
    input clk, rst, closed,
    input [4:0] floor_select,
    output reg [4:0] target_floors,
    output reg move_floors
);
    parameter IDLE = 0; //Espera a que se cierre la puerta 
    parameter WAIT = 1; // Espera a recibir la seleccion de piso al que moverse
    parameter DELAY = 2; //Espera tres segundos para empeza a moverse
    parameter DONE = 3; //Comienza a moverse al piso seleccionado

    reg [1:0] current_state;
    reg [1:0] next_state;

    wire slow_clk;
    reg clk_ctr;
    reg ctr_enable;
    reg [2:0] delay;
    reg complete;

    clk_divider #(.FREQ(1)) DELAY_CTR(
        .clk(clk),
        .rst(rst),
        .clk_div(slow_clk)
    );
    
    always @(posedge clk or posedge rst)
    begin
        if(rst)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    always @(current_state or floor_select)
    begin
        case(current_state)
        IDLE:
            begin
               if(closed == 0)
                    next_state <= IDLE;
                else
                    next_state <= WAIT; 
            end
        WAIT:
            begin
                if(floor_select == 0)
                    next_state <= WAIT;
                else
                    next_state <= DELAY;
            end
        DELAY:  
            begin
                if(!complete)
                    next_state <= DELAY;
                else
                    next_state <= DONE;

            end
        DONE:   
            begin
                next_state <= IDLE;
            end
        endcase
    end

    always @(current_state or floor_select)
    begin
        IDLE:
            begin
                move_floors <= 0; 
                ctr_enable <= 0;
            end
        WAIT:
            begin
                move_floors <= 0;
                ctr_enable <= 0;
            end
        DELAY:
            begin
                move_floors <= 0;
                ctr_enable <= 1;
            end
        DONE:
            begin
                move_floors <= 1;
                ctr_enable <= 0;
            end
    end

    always @(posedge slow_clk or negedge rst)
    begin
        if(!rst)
            begin
                delay <= 0;
                complete <= 0;
            end
        else
            begin
                if(counter_enable)
                    begin
                        if(delay >= 3)
                        begin
                            delay <= 0;
                            complete <= 1;
                        end
                        else
                        begin
                            delay <= delay + 1;
                            complete <= 0;
                        end
                     end
                else
                   delay <= delay;
            end 
    end

    always @(posedge clk)
    begin
        if(floor_select != 0 & current_state == WAIT)
            begin
                casex (floor_select)
                    5'b1xxxx:
                        target_floors <= 5;
                    5'b01xxx:
                        target_floors <= 4;
                    5'b001xx:
                        target_floors <= 3;
                    5'b0001x:
                        target_floors <= 2;
                    5'b00001:  
                        target_floors <= 1;
                    default:
                        target_floors <= 1;
                endcase
            end
        else
            target_floors <= target_floors;
    end
endmodule