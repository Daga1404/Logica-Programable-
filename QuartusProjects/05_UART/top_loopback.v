module top_loopback (
    input clk,           
    input rst,           
    input btn,          
    input [7:0] sw,     
    output [7:0] leds,  
    output serial_tx,   
    input serial_rx    
);

    wire send_pulse;

    debounce debouncer (
        .clk(clk),
        .btn(btn),
        .out(send_pulse)
    );


    tx transmitter (
        .data(sw),
        .send_data(send_pulse),
        .clk(clk),
        .rst(rst),
        .serial_out(serial_tx)
    );

    receiver #(
        .COUNTS_PER_BIT(434),
        .DATA_BITS(8)
    ) uart_receiver (
        .serial_data_in(serial_rx),
        .clk(clk),
        .rst(rst),
        .parity_type(2'b01),  
        .parity_error(),    
        .parallel_out(leds)
    );
endmodule
