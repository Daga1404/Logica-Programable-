module memory_RAM #(parameter NBits = 7, NAddr = 3)(

	input clk, rst_a,
	input wr_en,
	input [NBits - 1 : 0] Data_in,
	
	input [NAddr - 1 : 0] Data_address,
	
	output reg [NBits - 1 : 0] Data_out

);

reg [NBits - 1 : 0] RAM [0 : (2**NAddr) - 1];

always @(posedge clk or negedge rst_a)
begin
	if(!rst_a)
	begin
		RAM[Data_address] <= 'd0;
	end
	else
	begin
		if(!wr_en)
		begin
			RAM[Data_address] <= Data_in;
		end
	end
	
	Data_out <= RAM[Data_address];
end

endmodule 
