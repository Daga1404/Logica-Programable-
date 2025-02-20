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