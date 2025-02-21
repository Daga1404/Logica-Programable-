module decoder_0_F (
    input wire [3:0] decoder_in,
    output reg [0:6] decoder_out
);
always @(decoder_in) 
    begin
        case (decoder_in)
        0:decoder_out=1; 
        1:decoder_out=7'h4f;
        2:decoder_out=7'h12;
        3:decoder_out=7'h06;
        4:decoder_out=7'h4c;
        5:decoder_out=7'h24;
        6:decoder_out=7'h20;
        7:decoder_out=7'h0f;
        8:decoder_out=7'h00;
        9:decoder_out=7'h0C;
        4'hA:decoder_out=7'h08;
        4'hB:decoder_out=7'h60;
        4'hC:decoder_out=7'h31;
        4'hD:decoder_out=7'h42;
        4'hE:decoder_out=7'h30;
        4'hF:decoder_out=7'h38;
        default: decoder_out = 7'b1111111;
    endcase
end

endmodule
