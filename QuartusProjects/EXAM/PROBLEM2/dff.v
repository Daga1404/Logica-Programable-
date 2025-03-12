module dff (
    input slow_clk, d, 
    output reg q
);

always @(posedge slow_clk)
begin
    q <= d;
end
    
endmodule