//Decodificador de binario a decimal con salida en displays de 7 segmentos

module bcd_decoder #(
    parameter IN = 6,
    parameter S = 7
)(
    input [IN-1:0] bcd_in,
    output [0:S-1] bcd_out1, bcd_out2
);
    wire [3:0] unidades, decenas;

    //Unidades %10
    assign unidades = bcd_in % 10;
    //Decenas %100 / 10
    assign decenas = bcd_in %100 /10;

decoder_0_F D1(
    .decoder_in(unidades),
    .decoder_out(bcd_out1)
);
decoder_0_F D2(
    .decoder_in(decenas),
    .decoder_out(bcd_out2)
);  
endmodule