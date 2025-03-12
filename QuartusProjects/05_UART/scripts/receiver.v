// Receptor
module receiver #(
		parameter COUNTS_PER_BIT = 434,
			DATA_BITS = 8,
			CLOCK_CTR_WIDTH = 32,
            D_IDX_WIDTH = (DATA_BITS > 1) ? $clog2(DATA_BITS) : 1 // Que genere al menos 1
	)(
	input serial_data_in,
	input clk,
	input rst,
	input [1:0] parity_type, // 0: Sin paridad, 1: Paridad impar, 2: Paridad par
	output reg parity_error,
	output reg [DATA_BITS-1:0] parallel_out
);

localparam base_freq = 50_000_000;
// Quiero una señal que este a cierto baud rate
// Quiero saber cuantos ciclos de reloj de 50MHz me dan 115_200
localparam baudrate = 115_200;

localparam counts_per_bit = base_freq / baudrate;

// FALTA EL ESTADO DE PARIDAD
localparam RX_IDLE = 0;
localparam RX_START = 1;
localparam RX_DATA = 2;
localparam RX_PARITY = 3;
localparam RX_STOP = 4;

reg [2:0] active_state;
reg [1:0] parity_type_reg; // Registro para alimentar la paridad seleccioanda
reg parity_bit;        // Bit de paridad calculado
reg [CLOCK_CTR_WIDTH-1:0] clock_ctr; // Contador
reg [D_IDX_WIDTH-1:0] d_idx; // Indice de input data para saber que bit estamos usando

always @(posedge clk or posedge rst) 
	begin
		if (rst) 
			begin
				active_state <= RX_IDLE;
				parallel_out <= 0;
				clock_ctr <= 0;
				d_idx <= 0;
				parity_type_reg <= 0;
			end
		else if (active_state == RX_IDLE)
			if (^parity_type === 1'bX || parity_type === 3)  
				parity_type_reg <= 0;  
			else
				parity_type_reg <= parity_type;
		case (active_state)
			RX_IDLE: 
				begin
					// Dejar parallel out en el estado mas reciente
					clock_ctr <= 0;
					d_idx <= 0;
					if(~serial_data_in)
						active_state <= RX_START;
					else
						active_state <= active_state;
				end 
			RX_START: 
				begin
					// Generar flanco de bajada para iniciar la transmision
					parallel_out <= 0; 
					parity_error <= 0; // Reiniciar error de paridad
					// Contar en el start a la mitad para evitar errores (defasa)
					if(clock_ctr < ((counts_per_bit - 1)/2))
						begin
							clock_ctr <= clock_ctr + 1;
							active_state <= RX_START;
						end
					else
						begin
							clock_ctr <= 0;
							active_state <= RX_DATA;
						end
				end 
			RX_DATA:
				begin
					// Las demas cuentas dcopletas porque ya estamos a la mitad
					if(clock_ctr < counts_per_bit - 1)
						begin
							clock_ctr <= clock_ctr + 1;
							active_state <= RX_DATA;	
						end
					else
						begin
							parallel_out[d_idx] <= serial_data_in;
							clock_ctr <= 0;
							if (d_idx < 7)
								begin
									d_idx <= d_idx + 1;
									active_state <= RX_DATA;
								end
							else
								begin
									d_idx <= 0;
									if(parity_type_reg == 0)
										active_state <= RX_STOP;
									else
										active_state <= RX_PARITY;
								end
						end
				end
			RX_PARITY:
				begin
					parity_bit = ^parallel_out;
					if (parity_type_reg == 1) 
					begin  // Paridad impar
						if (parity_bit == serial_data_in) 
							parity_error <= 1;  // Error si los bits de paridad coinciden
						else 
							parity_error <= 0;  // Correcto si son diferentes
					end
					else if (parity_type_reg == 2) 
					begin  // Paridad par
						if (parity_bit != serial_data_in) 
							parity_error <= 1;  // Error si los bits de paridad no coinciden
						else 
							parity_error <= 0;  // Correcto si son iguales
					end
					else 
						parity_error <= 0;  // Si no hay paridad, no hay error

					if (clock_ctr < counts_per_bit - 1)
						begin
							clock_ctr <= clock_ctr + 1;
							active_state <= RX_PARITY;
						end
					else
						begin
							clock_ctr <= 0;
							active_state <= RX_STOP;
						end					
				end
			RX_STOP: 
				begin
					if( clock_ctr < counts_per_bit - 1)
						begin
							clock_ctr <= clock_ctr + 1;
							active_state <= RX_STOP;
						end
					else
						active_state <= RX_IDLE;
				end 
		endcase	
	end

endmodule