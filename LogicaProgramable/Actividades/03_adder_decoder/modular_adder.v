// Sumador con capacidad modular y de escalamiento
module modular_adder #(
    // Declaración del parámetro "N" referente al número de bits que se introducirán al sumador
    parameter N = 5
) (
    // Declaración de puertos 
    input [N-1:0] A, B,
    output [N:0] sum
);
    // Señal auxiliar para el carry-out del sumador
    wire [N-1:0] c_wire;

    // Primera instancia del módulo full_adder
    full_adder FA0 (
        .a(A[0]), 
        .b(B[0]), 
        .cin(0), 
        .s(sum[0]), 
        .cout(c_wire[0])
    );

    // Variable de generación "i" para crear las instancias del módulo full_adder
    genvar i;
    // Ciclo de generación que instancia el módulo full_adder las veces requeridas de 1 a N-1
    generate
        for (i = 1; i < N; i = i + 1) 
        begin: adder_loop
            full_adder FA (
                .a(A[i]), 
                .b(B[i]), 
                .cin(c_wire[i-1]),  // Se usa el carry-out anterior
                .s(sum[i]), 
                .cout(c_wire[i])
            );
        end
    endgenerate

    // Asignación del carry final a sum[N]
    assign sum[N] = c_wire[N-1];

endmodule
