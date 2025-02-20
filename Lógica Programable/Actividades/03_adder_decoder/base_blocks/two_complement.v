module two_complement #(
    parameter WIDTH = 5 // Default width
)(
    input  wire [WIDTH-1:0] in,  // Input number
    output wire [WIDTH-1:0] out  // Two's complement output
);

    assign out = ~in + 1'b1; // Compute two's complement

endmodule
