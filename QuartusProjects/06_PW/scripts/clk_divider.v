module clk_divider #(
    parameter FREQ = 50_000_000
)(
    input clk,
    input rst,
    output reg clk_div
);

    reg [31:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
            clk_div <= 0;
        end else if (count >= (FREQ/2 - 1)) begin
            count <= 0;
            clk_div <= ~clk_div;
        end else begin
            count <= count + 1;
        end
    end
endmodule
