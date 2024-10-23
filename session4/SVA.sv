module vending_machine_sva(vending_machine_interface.dut svamach);

property m1;
@(posedge svamach.clk) svamach.D_in |-> (svamach.change&&svamach.dispense);
endproperty
property_for_first_assertion:assert property(m1);
cover_for_first_assertion:cover property(m1);

property m2;
@(posedge svamach.clk) $rose(svamach.Q_in) |-> ##2(svamach.dispense);
endproperty
property_for_second_assertion:assert property(m2);
cover_for_second_assertion:cover property(m2);

property m3;
@(posedge svamach.clk) svamach.Q_in |-> !(svamach.change);
endproperty
property_for_third_assertion:assert property(m3);
cover_for_third_assertion:cover property(m3);
endmodule
