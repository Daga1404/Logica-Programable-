module clk_divider #(
    parameter CONST_N = 3;
) (
    input clk,
    input rst,
    output reg clk_div
);

    reg [ceillog2(CONST_N)-1:0] count;

    always @(posedge clk or posedge rst)
        begin
            if (rst)
                begin
                    count <= 0;
                end
            else if (count == CONST_N-1)
                begin
                    count <= 0;
                end
            else
                begin
                    count <= count + 1;
                end
        end

    always @(posedge clk or posedge rst)
        begin
            if (rst)
                begin
                    clk_div <= 0;
                end
            else if (count == CONST_N-1)
                begin
                    clk_div <= ~clk_div;
                end
            else
                begin
                    clk_div <= clk_div;
                end
        end

// log function

    function integer ceillog2;
        input integer data;
        integer i, result;
            begin
                for (i = 0; 2**i < data; i = i+1)
                    begin
                        result = i + 1;
                        ceillog2 = result;
                    end
            end 
    endfunction   
endmodule