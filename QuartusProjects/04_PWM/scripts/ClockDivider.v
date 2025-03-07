module ClockDivider #(parameter FREQ = 50)(
    input clk, rst,
    output reg clk_div
);
    localparam CLK_FREQ = 50_000_000;
    localparam COUNT_MAX = CLK_FREQ / (2*FREQ);

    //reg [$clog2(CLK_FREQ)-1:0] count;
	 reg [31:0] count;

    always@(posedge clk or posedge rst)
        begin
            if(rst)
            count<=0;

            else if (count==COUNT_MAX-1)
            count<=0;

            else
            count<= count+1;
        end

    always@(posedge clk or posedge rst)
        begin
            if(rst==1)
            clk_div<=0;

            else if (count==COUNT_MAX-1)
            clk_div<=~clk_div;

            else
            clk_div<=clk_div;
        end

endmodule