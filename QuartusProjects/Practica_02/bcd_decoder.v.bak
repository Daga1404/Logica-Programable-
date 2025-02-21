//Decodificador de binario a decimal con salida en displays de 7 segmentos

module bcd_decoder #(
    parameter IN = 10,
    parameter S = 7
)(
    input [IN-1:0] SW,
    output [0:S-1] HEX0, HEX1, HEX2, HEX3
);
    wire [3:0] unidades, decenas, centenas, miles;

    //Unidades %10
    assign unidades = SW % 10;
    //Decenas %100 / 10
    assign decenas = SW %100 /10;
    //Centenas %1000 / 100
    assign centenas = SW %1000 / 100;
    //Miles /1000
    assign miles = SW /1000;

decoder_0_F D1(
    .decoder_in(unidades),
    .decoder_out(HEX0)
);
decoder_0_F D2(
    .decoder_in(decenas),
    .decoder_out(HEX1)
);
decoder_0_F D3(
    .decoder_in(centenas),
    .decoder_out(HEX2)
);
decoder_0_F D4(
    .decoder_in(miles),
    .decoder_out(HEX3)
);
    
endmodule