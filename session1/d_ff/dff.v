module dff #(parameter USE_EN = 1) (clk, rst, d, q, en);
input clk, rst, d, en;
output reg q;

always @(posedge clk) begin 
   if (rst)
      q <= 0;
   else
      if(USE_EN)
         if (en)
            q <= d;
         else 
            q <= q;
      else 
         q <= d;
end 

endmodule
