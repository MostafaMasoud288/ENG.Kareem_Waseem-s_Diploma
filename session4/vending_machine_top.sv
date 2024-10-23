module vending_machine_top();
bit clk;
	//clock generation
  initial begin
    clk = 0;
    forever
      #1 clk = ~clk;
  end
vending_machine_interface inter(clk);
vending_machine dut (inter);
vending_machine_tb test (inter);
vending_machine_monitor monitor (inter);
bind vending_machine vending_machine_sva init(inter);

endmodule
