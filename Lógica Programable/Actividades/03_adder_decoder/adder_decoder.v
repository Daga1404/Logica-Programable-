module adder_decoder #(
    parameter N = 5,
    parameter SEGMENT = 7
)
(
    // Entradas del módulo full_adder
    input [N-1:0] A, B,
    // Salida del módulo decoder_0_F
    output [0:SEGMENT-1] D_units, D_dec
);

// Señales auxiliares
wire [N:0] aux_sum;
wire [3:0] aux_unit;
wire [3:0] aux_dec;

// Instancia del módulo modular_adder
modular_adder ADDER(
    .A(A),
    .B(B),
    .sum(aux_sum)
);

assign aux_unit = aux_sum % 10;
assign aux_dec = aux_sum / 10; 

// Instancias del módulo decoder_0_F
decoder_0_F D1(
    .decoder_in(aux_unit),
    .decoder_out(D_units)
);
decoder_0_F D2(
    .decoder_in(aux_dec),
    .decoder_out(D_dec)
);

endmodule
