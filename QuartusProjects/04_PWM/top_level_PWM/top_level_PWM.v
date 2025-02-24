module top_level_PWM (
    input pb_inc, pb_dec, clk, rst,
    output pwm_out
);
    wire neg_pb_inc = ~pb_inc;
    wire neg_pb_dec = ~pb_dec;
    wire slow_clk;
    wire debounced_pb_inc, debounced_pb_dec;

    reg [31:0] DC, DC_counter;


    parameter base_freq = 50_000_000;
    parameter target_freq = 50;
    parameter counts = base_freq / target_freq;
    parameter X = counts / 100;

    // Reducción de frecuencia de clk
    clk_divider u1(
        .clk(clk),
        .rst(rst),
        .clk_div(slow_clk)
    );

    //Generar debouncer para pb_inc y pb_dec
    debouncer INCREASE(
        .clk(slow_clk),
        .pb_in(neg_pb_inc),
        .rst(rst),
        .pb_out(debounced_pb_inc)
    );    
    debouncer DECREASE(
        .clk(slow_clk),
        .pb_in(neg_pb_dec),
        .rst(rst),
        .pb_out(debounced_pb_dec)
    );

    //Generar duty-cycle PWM

    //Logica de incremento y decremento del duty-cycle
    always @(posedge slow_clk or negedge rst)
        begin
            if (debounced_pb_dec)
            DC <= DC - X;
            else if (debounced_pb_inc)
            DC <= DC + X;
        end

    //Contador del clock rapido para generar el duty-cycle
    always @(posedge clk or negedge rst)
        begin
            if (rst)
            DC_counter <= 0;
            else if (DC_counter )
        end


endmodule