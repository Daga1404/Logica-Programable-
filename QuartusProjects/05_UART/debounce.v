module debounce (
    input clk,
    input btn,
    output reg out
);
    reg [15:0] counter;
    reg btn_sync_0, btn_sync_1;

    
    always @(posedge clk) begin
        btn_sync_0 <= btn;
        btn_sync_1 <= btn_sync_0;
    end

    always @(posedge clk) begin
        if (btn_sync_1)
            counter <= counter + 1;
        else
            counter <= 0;
    end

    
    always @(posedge clk) begin
        if (counter == 16'hFFFF)
            out <= 1;
        else
            out <= 0;
    end
endmodule