module clk_divider #(parameter FREQ=50000000) 
(
    input clk, rst,
    output reg clk_div
);
    reg [31:0] count;

    always @(posedge clk or posedge rst)
    begin
        if (rst)
            count <= 0;
        else if (count >= (FREQ/2 - 1)) begin
            count <= 0;
            clk_div <= ~clk_div;
        end
        else
            count <= count + 1;
    end
endmodule