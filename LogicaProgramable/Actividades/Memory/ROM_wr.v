module ROM_wr (
    input [1:0] KEY,
    input [9:0] SW,
    output [10:0] LEDR
);

    ROM wrapper(
        .ce(KEY[0]),
        .read_en(KEY[1]),
        .addr(SW[9:0]),
        .data(LEDR),
    );
    
endmodule