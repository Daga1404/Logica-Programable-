module top_level_counter #(
    // No parameters needed
)(
    input CLOCK_50, 
    input [9:0] SW,
    output [9:0] LEDR
);
    wire DB_to_OS, OS_to_COUNT;
    
    // Debouncer
    debouncer DB (
        .clk(CLOCK_50),
        .rst_a_p(SW[9]),
        .debouncer_in(SW[0]),
        .debouncer_out(DB_to_OS)
    );
    
    // One-Shot
    one_shot OS (
        .clk(CLOCK_50),
        .button(DB_to_OS),
        .one_shot_button(OS_to_COUNT)
    );
    
    // Counter
    counter COUNT (
        .clk(CLOCK_50),
        .rst(SW[9]),
        .enable(OS_to_COUNT),
        .count(LEDR[3:0])
    );
endmodule