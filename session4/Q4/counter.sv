////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: Counter Design 
// 
////////////////////////////////////////////////////////////////////////////////
module counter (counter_interface.dut inter);


always @(posedge inter.clk or negedge inter.rst_n) begin
    if (!inter.rst_n)
        inter.count_out <= 0;
    else if (!inter.load_n)
        inter.count_out <= inter.data_load;
    else if (inter.ce) begin
        if (inter.up_down)
            inter.count_out <= inter.count_out + 1;
        else 
            inter.count_out <= inter.count_out - 1;
    end
end

assign inter.max_count = (inter.count_out == {inter.WIDTH{1'b1}})? 1:0;
assign inter.zero = (inter.count_out == 0)? 1:0;

endmodule