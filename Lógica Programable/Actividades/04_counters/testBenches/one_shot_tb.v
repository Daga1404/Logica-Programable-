module one_shot_tb (
    input reg clk, button,
    output wire button_out
);  
    one_shot DUT (
        .clk(clk),
        .button(button),
        .one_shot_button(button_out)
);
    always
    begin
        #1 clk = ~clk;
    end

    initial
    begin
        clk = 0;
        button = 0;
        #10;
        button = 1;
        #100;
        button = 0;
        #10;
        button = 1;
        #50;
        $stop
    end
endmodule