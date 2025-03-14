module test_clocl (
    input MAX10_CLK1_50,
    output reg [0:0] LEDR
);

    reg [24:0] counter;
	 
	 clk_divider #(.FREQ(25_000_000)) CD (
        .clk(MAX10_CLK1_50),
        .rst(0),
        .clk_div(clk)
    );

    always @(posedge MAX10_CLK1_50) begin
        counter <= counter + 1;
        if (counter == 25000000) begin  // Parpadeo cada segundo (aprox)
            LEDR[0] <= ~LEDR[0];
            counter <= 0;
        end
    end
endmodule