module subtracter #(
    parameter N = 5
)(
    input [N-1:0] A,B,
    output [N-1:0] subt
);
wire [N-1:0] aux;

two_complement comp(
    .in(B),
    .out(aux)
)

modular_adder subtract(
    .A(A),
    .B(B),
    sum(subt)
)
    
endmodule