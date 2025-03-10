module seg7(
		
	input [3:0] in,
	
	output reg [6:0] display
);

always @(in)
begin
	case(in)
		0:
			display = 7'b1000000;
		1:
			display = 7'h79;
		2:
			display = 7'h24;
		3:
			display = 7'h30;
		4:
			display = 7'h19;
		5:
			display = 7'h12;
		6:
			display = 7'h02;
		7:
			display = 7'h78;
		8:
			display = 7'h00;	
		9:
			display = 7'h18;
		default:
			display = 7'h0111111;
	endcase
end
endmodule 