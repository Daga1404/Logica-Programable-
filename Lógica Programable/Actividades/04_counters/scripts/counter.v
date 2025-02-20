module counter #(
    // No parameters needed
)(
    input clk, rst, enable,
    output reg [3:0] count
);
    always @(posedge clk) 
        begin
            if (rst)
                count <= 4'b0000;
            else if (enable)
                count <= count + 1;
        end
endmodule