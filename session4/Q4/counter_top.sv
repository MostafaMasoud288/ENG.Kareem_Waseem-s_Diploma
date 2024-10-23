module counter_top();
bit clk;
	//clock generation
  initial begin
    clk = 0;
    forever begin
      #5 clk = ~clk;
    end
  end
counter_interface inter(clk);
counter DUT (inter);
counter_tb TEST (inter);
bind counter counter_sva INIT(inter);

endmodule
