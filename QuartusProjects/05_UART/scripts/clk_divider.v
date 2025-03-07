module clk_divider #(parameter FREQ = 50)(
    input clk, rst,
    output reg clk_div
);
    localparam CLK_FREQ = 50_000_000;
    localparam COUNT_MAX = CLK_FREQ / (2*FREQ);

    reg [31:0] count;

    always @(posedge clk or negedge rst)
    begin
        if (~rst)  // Active-low reset to match other modules
        begin
            count <= 0;
            clk_div <= 0;
        end
        else 
        begin
            if (count == COUNT_MAX-1)
            begin
                count <= 0;
                clk_div <= ~clk_div;
            end
            else
            begin
                count <= count + 1;
                clk_div <= clk_div;
            end
        end
    end
endmodule