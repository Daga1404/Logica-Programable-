module fsm_detect (

input clk,
rst_a_p,
enable,

output reg FSM_out_led, FSM_out_BCD

);

parameter A = 0,
		  B = 1,
		  C = 2,
    	  D = 3;
			 
// registros para guardar estado
reg [1:0] current_state;
reg [1:0] next_state;

// 1er always dependiente del reloj y actualiza current_state
always @(posedge clk or posedge rst_a_p)
begin
	if(rst_a_p)
		current_state <= A;
	else
		current_state <= next_state;
end	

// 2do always dependiente del estado actual y de las señales de entrada
always @(current_state or enable)
begin

	case(current_state)
	A:
		begin
			if(enable == 0)
				next_state = A;
			else
				next_state = B;
		end
	
	B:
        begin
            if(enable == 0)
                next_state = A;
            else
                next_state = C;
        end
    C:
        begin
            if(enable == 0)
                next_state = A;
            else
                next_state = D;
        end
    D:
        begin
            if(enable == 0)
                next_state = A;
            else
                next_state = D;
        end
    endcase

end

always @(current_state, enable)
begin
    case(current_state)
    A:
        begin
            FSM_out_led = 0;
            FSM_out_BCD = 0;
        end
    B:
        begin
            FSM_out_led = 0;
            FSM_out_BCD = 1;
        end
    C:
        begin
            FSM_out_led = 0;
            FSM_out_BCD = 2;
        end
    D:
        begin
            FSM_out_led = 1;
            FSM_out_BCD = 3;
        end
    endcase
end

endmodule