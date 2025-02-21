module one_shot(
    input clk, button,
    output reg one_shot_button
);
    reg delay_button;
    always @(posedge clk)
        begin
            delay_button <= button;
            one_shot_button <= (delay_button ^ button) & button;
        end
endmodule