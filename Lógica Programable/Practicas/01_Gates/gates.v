// Code your design here
module gates (
  input wire in_a, in_b,
  
  output wire [7:0] z_out
);
  always @(*)
    begin
      z_out[0] = a_in & b_in; 
      z_out[1] = a_in | b_in;
      z_out[2] = a_in ^ b_in;
      z_out[3] = !b_in;
      z_out[4] = a_in ~& b_in;
      z_out[5] = a_in ~| b_in;
      z_out[6] = a_in ~^ b_in;
      z_out[7] = !a_in;
    end
endmodule
                          