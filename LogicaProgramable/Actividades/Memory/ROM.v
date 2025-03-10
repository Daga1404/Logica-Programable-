module ROM #(parameter DATA_WIDTH = 8, ADDRESS_WIDTH = 8)(
    input ce, read_en,
    input [ADDRESS_WIDTH-1:0] addr,
    output [DATA_WIDTH-1:0] data
);
    reg [DATA_WIDTH-1:0] mem [2**ADDRESS_WIDTH-1:0];

initial 
begin
    $readmemb("ROM_bin.bin", mem);
end

assign data = (ce && read_en) ? mem[addr] : 8'b0;


    
endmodule