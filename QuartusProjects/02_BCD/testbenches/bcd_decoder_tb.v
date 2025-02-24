module bcd_decoder_tb();

    // Parameters
    parameter IN = 10;
    parameter S = 7;

    // Inputs
    reg [IN-1:0] SW;

    // Outputs
    wire [0:S-1] HEX0, HEX1, HEX2, HEX3;

    // Instantiate the Unit Under Test (DUT)
    bcd_decoder #(
        .IN(IN),
        .S(S)
    ) DUT (
        .SW(SW),
        .HEX0(HEX0),
        .HEX1(HEX1),
        .HEX2(HEX2),
        .HEX3(HEX3)
    );

    initial begin
        // Initialize Inputs
        SW = 0;

        // Wait 100 ns for global reset to finish
        #100;

        // Add stimulus here
        SW = 10'b0000000001; // Test case 1
        #10;
        SW = 10'b0000001010; // Test case 2
        #10;
        SW = 10'b0000010100; // Test case 3
        #10;
        SW = 10'b0001100100; // Test case 4
        #10;
        SW = 10'b0010011000; // Test case 5
        #10;

        // Finish simulation
        $finish;
    end

endmodule