//Full adder
//Two one-bit inputs
//Seven segment display output

module full_adder (
    input wire a,
    input wire b,
    input wire cin,
    output wire s,
    output wire cout 
);

    assign s = a ^ b ^ cin;  // Sum = XOR of inputs
    assign cout = a & b | a & cin | b & cin;  // Carry = AND of inputs
endmodule
