/*module ARM_PWM (
    input MAX10_CLK1_50,
    input [1:0] KEY,
    input [9:0] SW,
    output [35:0] GPIO
);
// Mapping Acceleration Values to PWM Duty Cycle (0-100%)
wire [7:0] duty_x, duty_y, duty_z;

assign duty_x = ((data_x + 16'sd32768) * 100) / 16'sd65535;
assign duty_y = ((data_y + 16'sd32768) * 100) / 16'sd65535;
assign duty_z = ((data_z + 16'sd32768) * 100) / 16'sd65535;

// PWM Module Instantiation
pwm_module pwm_x_inst (
    .clk(clk),
    .reset_n(reset_n),
    .duty_cycle(duty_x),
    .pwm_out(GPIO[0])
);

pwm_module pwm_y_inst (
    .clk(clk),
    .reset_n(reset_n),
    .duty_cycle(duty_y),
    .pwm_out(GPIO[1])
);

pwm_module pwm_z_inst (
    .clk(clk),
    .reset_n(reset_n),
    .duty_cycle(duty_z),
    .pwm_out(GPIO[2])
);
endmodule*/