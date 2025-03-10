module counter #(
    parameter OUT_WIDTH = 6
)(
    input clk, rst, enable,
    output reg [OUT_WIDTH-1:0] count
);
    always @(posedge clk or posedge rst) 
        begin
            if (rst)
                count <= 4'b0000;
            else if (enable)
                count <= count + 1;
            else 
                count <= count;
        end
endmodule