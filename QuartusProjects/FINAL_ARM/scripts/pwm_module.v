module pwm_module (
    input clk,
    input reset_n,
    input [7:0] duty_cycle, // 0-100% duty cycle
    output reg pwm_out
);

reg [7:0] counter;

always @(posedge clk or negedge reset_n) begin
    if (!reset_n)
        counter <= 0;
    else
        counter <= counter + 1;
end

always @(posedge clk or negedge reset_n) begin
    if (!reset_n)
        pwm_out <= 0;
    else
        pwm_out <= (counter < duty_cycle) ? 1 : 0;
end

endmodule
