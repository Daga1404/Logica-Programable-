// Transmisor
module transmitter#(
		parameter COUNTS_PER_BIT = 434,
			DATA_BITS = 8,
			CLOCK_CTR_WIDTH = 32,
            D_IDX_WIDTH = (DATA_BITS > 1) ? $clog2(DATA_BITS) : 1 // Que genere al menos 1
)(
	input [DATA_BITS-1:0] data,
	input send_data,
	input clk,
	input rst,
	input [1:0] parity_type, // 0: Sin paridad, 1: Paridad impar, 2: Paridad par
	output reg serial_out
);

localparam counts_per_bit = COUNTS_PER_BIT;

// FALTA EL ESTADO DE PARIDAD
localparam TX_IDLE = 0;
localparam TX_START = 1;
localparam TX_DATA = 2;
localparam TX_PARITY = 3;
localparam TX_STOP = 4;

reg [2:0] active_state;
reg [1:0] parity_type_reg; // Registro para alimentar la paridad seleccioanda
reg parity_bit;        // Bit de paridad calculado
reg [CLOCK_CTR_WIDTH-1:0] clock_ctr; // Contador
reg [D_IDX_WIDTH-1:0] d_idx; // Indice de input data para saber que bit estamos usando

always @(posedge clk or posedge rst) 
	begin
		if (rst) 
			begin
				active_state <= TX_IDLE;
				serial_out <= 1;
				clock_ctr <= 0;
				d_idx <= 0;
				parity_type_reg <= 0;
			end
		else if (active_state == TX_IDLE)
			if (^parity_type === 1'bX || parity_type === 3)  
				parity_type_reg <= 0;  
			else
				parity_type_reg <= parity_type;
		case (active_state)
			TX_IDLE: 
				begin
					serial_out <= 1;
					clock_ctr <= 0;
					if(send_data)
						active_state <= TX_START;
					else
						active_state <= TX_IDLE;
				end 
			TX_START: 
				begin
					// Generar flanco de bajada
					// No se si ponerle el = o el <=
					serial_out <= 0;
					if(clock_ctr < counts_per_bit - 1)
						begin
							clock_ctr <= clock_ctr + 1;
							active_state <= TX_START;
						end
					else
						begin
							clock_ctr <= 0;
							active_state <= TX_DATA;
						end
				end 
			TX_DATA:
				begin
					serial_out <= data[d_idx];
					if(clock_ctr < counts_per_bit - 1)
						begin
							clock_ctr <= clock_ctr + 1;
							active_state <= TX_DATA;	
						end
					else
						begin


							clock_ctr <= 0;
							if (d_idx < 7)
								begin
									d_idx <= d_idx + 1;
									active_state <= TX_DATA;
								end
							else
								begin
									d_idx <= 0;
									if (parity_type_reg == 0) 
										active_state <= TX_STOP;
									else
										active_state <= TX_PARITY;
								end
						end
				end
			TX_PARITY:
				begin
					parity_bit = ^data;
					
					if (parity_type_reg  == 1)  // Paridad impar
						serial_out <= ~parity_bit;
					else if (parity_type_reg  == 2) // Paridad par
						serial_out <= parity_bit;

					if (clock_ctr < counts_per_bit - 1)
						begin
							clock_ctr <= clock_ctr + 1;
							active_state <= TX_PARITY;
						end
					else
						begin
							clock_ctr <= 0;
							active_state <= TX_STOP;
						end
				end
			TX_STOP: 
				begin
					serial_out <= 1;
					if( clock_ctr < counts_per_bit - 1)
						begin
							clock_ctr <= clock_ctr + 1;
							active_state <= TX_STOP;
						end
					else
						active_state <= TX_IDLE;
				end
		endcase	
	end

endmodule