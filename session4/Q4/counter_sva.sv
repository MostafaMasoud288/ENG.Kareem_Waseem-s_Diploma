module counter_sva(counter_interface.sva inter);

always_comb begin
if(!inter.rst_n)
a_reset: assert final(inter.count_out == 0);
end

property load;
@(negedge inter.clk) (inter.rst_n &&!inter.load_n) |-> (inter.count_out == inter.data_load);
endproperty
assert property(load);
cover property(load);

property no_change;
@(negedge inter.clk) (inter.rst_n && inter.load_n && !inter.ce) |-> $stable(inter.count_out);
endproperty
assert property(no_change);
cover property(no_change);

property increment;
@(negedge inter.clk) (inter.rst_n && inter.load_n && inter.ce && inter.up_down) |->(inter.count_out == $past(inter.count_out)+1'b1) ;
endproperty
assert property(increment);
cover property(increment);

property decrement;
@(negedge inter.clk) (inter.rst_n && inter.load_n && inter.ce && !inter.up_down) |->(inter.count_out == $past(inter.count_out)-1'b1) ;
endproperty
assert property(decrement);
cover property(decrement);

property max_case;
@(negedge inter.clk) (inter.count_out==4'b1111) |-> inter.max_count ;
endproperty
assert property(max_case);
cover property(max_case);

property zero_case;
@(negedge inter.clk) (inter.count_out==4'b0000) |-> inter.zero ;
endproperty
assert property(zero_case);
cover property(zero_case);


endmodule
