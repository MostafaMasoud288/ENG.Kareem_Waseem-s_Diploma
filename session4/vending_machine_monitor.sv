module vending_machine_monitor(vending_machine_interface.monitor machmon);
initial begin
    $monitor("rstn = %b, clk = %b, Q_in = %b, D_in = %b, dispense = %b, change = %b", machmon.rstn, machmon.clk, machmon.Q_in, machmon.D_in, machmon.dispense, machmon.change);
  end

endmodule
