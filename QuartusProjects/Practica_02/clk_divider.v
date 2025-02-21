module clk_divider #(parameter constantN=5000000)
(

input clk, rst,

output reg clk_div

);

reg [$clog2(constantN)-1:0] count;

always@(posedge clk or posedge rst)
begin

if(rst)
count<=0;

else if (count==constantN-1)
count<=0;

else
count<= count+1;

end

always@(posedge clk or posedge rst)
begin


if(rst==1)
clk_div<=0;

else if (count==constantN-1)
clk_div<=~clk_div;

else
clk_div<=clk_div;

end

endmodule