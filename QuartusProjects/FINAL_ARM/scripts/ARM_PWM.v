module ARM_PWM (
    input MAX10_CLK1_50,
  
    input rst,
	 
	 output [35:0] GPIO,
	 
	 input [9:0] SW,
	 
	 input [1:0] KEY
	 
);



// PWM Module Instantiation
PWM PWM_X(
    .clk(MAX10_CLK1_50),
    .enable(SW[0]),
    .btn_up(KEY[0]),
	 .btn_down(KEY[1]),
    .PWM(GPIO[0])
);

PWM PWM_Y(
    .clk(MAX10_CLK1_50),
    .enable(SW[1]),
    .btn_up(KEY[0]),
	 .btn_down(KEY[1]),
    .PWM(GPIO[2])
);

PWM PWM_Z(
    .clk(MAX10_CLK1_50),
    .enable(SW[2]),
    .btn_up(KEY[0]),
	 .btn_down(KEY[1]),
    .PWM(GPIO[4])
);
endmodule