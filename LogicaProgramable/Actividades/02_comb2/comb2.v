// Code your design here
module comb2(
    input [5:0] data_in,
    output reg [2:0] data_out
);
always @(data_in)
 begin
    case (data_in)
     6'b101010: 
        data_out = 3'b111;
     6'b101100: 
        data_out = 3'b010;
     6'b101101: 
        data_out = 3'b110;
     6'b011011: 
        data_out = 3'b011;
     6'b101111: 
        data_out = 3'b001;
     default:
        data_out = 0;  
    endcase
    
end
    
endmodule