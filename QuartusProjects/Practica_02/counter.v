module counter #(
    parameter OUT_WIDTH = 7
)(
    input clk, rst, enable,
    output reg [OUT_WIDTH-1:0] count
);
    always @(posedge clk) 
        begin
            if (rst)
                count <= 0;
            else if (enable)
                count <= count + 1;
            else 
                count <= count;
        end
endmodule