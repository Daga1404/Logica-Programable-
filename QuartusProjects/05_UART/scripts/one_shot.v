module one_shot(
    input clk, in_shot,
    output reg one_shot_button
);
    reg delay_button;
    always @(posedge clk)
        begin
            delay_button <= in_shot;
            one_shot_button <= (delay_button ^ in_shot) & in_shot;
        end
endmodule