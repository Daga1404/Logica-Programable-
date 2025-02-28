module decoder_0_F (
    input wire [3:0] decoder_in,
    output reg [6:0] decoder_out
);
    always @(decoder_in) 
    begin
        case (decoder_in)
            4'h0: decoder_out = 7'b1000000; // 0
            4'h1: decoder_out = 7'b1111001; // 1
            4'h2: decoder_out = 7'b0100100; // 2
            4'h3: decoder_out = 7'b0110000; // 3
            4'h4: decoder_out = 7'b0011001; // 4
            4'h5: decoder_out = 7'b0010010; // 5
            4'h6: decoder_out = 7'b0000010; // 6
            4'h7: decoder_out = 7'b1111000; // 7
            4'h8: decoder_out = 7'b0000000; // 8
            4'h9: decoder_out = 7'b0010000; // 9
            4'hA: decoder_out = 7'b0001000; // A
            4'hB: decoder_out = 7'b0000011; // b
            4'hC: decoder_out = 7'b1000110; // C
            4'hD: decoder_out = 7'b0100001; // d
            4'hE: decoder_out = 7'b0000110; // E
            4'hF: decoder_out = 7'b0001110; // F
            default: decoder_out = 7'b1111111; // Apagado
        endcase
    end
endmodule
