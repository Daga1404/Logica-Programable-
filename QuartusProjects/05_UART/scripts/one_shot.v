module one_shot(
    input clk, button,
    output reg one_shot_button
);
    reg prev_btn;

    always @(posedge clk)
        begin
            prev_btn <= button;
        end
        assign one_shot_button = ~button & prev_btn;
        
endmodule