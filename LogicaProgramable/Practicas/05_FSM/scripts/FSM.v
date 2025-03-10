module FSM (

input clk,
rst_a_p,
enable,

output reg FSM_out

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
                next_state = C;
            else
                next_state = B;
        end
    C:
        begin
            if(enable == 0)
                next_state = D;
            else
                next_state = B;
        end
    D:
        begin
            if(enable == 0)
                next_state = A;
            else
                next_state = B;
        end
    endcase

end

always @(current_state, enable)
begin
    case(current_state)
    D: 
        begin
            if(enable)
                FSM_out = 1;
            else
                FSM_out = 0;
        end
    default:
        FSM_out = 0;
    endcase
end

endmodule