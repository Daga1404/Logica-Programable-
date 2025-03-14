module clk_divider #(parameter DIVISOR=2) 
(
    input clk, rst,
    output reg clk_div
);
    reg [31:0] count;

    always @(posedge clk or posedge rst)
    begin
        if (rst) begin
            count <= 0;
            clk_div <= 0;
        end
        else if (count >= (DIVISOR/2 - 1)) begin
            count <= 0;
            clk_div <= ~clk_div;
        end
        else
            count <= count + 1;
    end
endmodule

