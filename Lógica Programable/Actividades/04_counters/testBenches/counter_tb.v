module counter_tb #(
    //parameters
)(
    input reg clk, rst, enable,
    output wire [3:0] count
);

`timescale 100/1000ps
initial begin
    clk = 0;
    enable = 0;
    rst = 0;

    #5 rst = 1;
    #10 rst = 0;
    #10 enable = 1;

    always 
    begin
        #5 clk = ~clk;
    end
end

endmodule