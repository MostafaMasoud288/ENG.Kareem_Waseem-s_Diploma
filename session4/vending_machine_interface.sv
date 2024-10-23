interface vending_machine_interface (clk);
	parameter WAIT = 2'b00;
	parameter Q_25 = 2'b01;
	parameter Q_50 = 2'b11;
	input clk;
        logic rstn, Q_in, D_in;
	logic dispense, change;
modport test (output rstn, Q_in, D_in,
              input clk,dispense, change);
modport dut (input clk,rstn, Q_in, D_in,
              output dispense, change);
modport monitor (input clk,rstn, Q_in, D_in,
               dispense, change);
endinterface
