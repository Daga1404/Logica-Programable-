module up_down_counter #(
    parameter OUT_WIDTH = 6,
    parameter MAX_COUNT = 59 // se lo agregue para el top 
)(
    input clk,
    input reset,
    input up_down,  
    input tick,     
    output reg [OUT_WIDTH-1:0] count
);

always @(posedge clk or posedge reset) begin
    if (reset) 
        count <= 0;
    else if (tick) begin
        if (up_down) begin
            if (count == MAX_COUNT)
                count <= 0;
            else
                count <= count + 1;
        end
        else begin
            if (count == 0)
                count <= MAX_COUNT;
            else
                count <= count - 1;
        end
    end
end

endmodule
