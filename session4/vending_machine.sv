module vending_machine(vending_machine_interface.dut intmach);

	reg [1:0] cs, ns; // cs >> current state, ns >> next state

	//Next State Logic
	always @(cs, intmach.Q_in, intmach.D_in) begin
		case (cs)
			intmach.WAIT: 
				if (intmach.Q_in)
					ns = intmach.Q_25;
				else 
					ns = intmach.WAIT;

			intmach.Q_25:
				if (intmach.Q_in)
					ns = intmach.Q_50;
				else 
					ns = intmach.Q_25;

			intmach.Q_50:
				if (intmach.Q_in)
					ns = intmach.WAIT;
				else 
					ns = intmach.Q_50;

			default: 	ns = intmach.WAIT;
		endcase
	end

	//State Memory
	always @(posedge intmach.clk or negedge intmach.rstn) begin
		if(~intmach.rstn)
			cs <= intmach.WAIT;
		else
			cs <= ns;
	end

	//Output Logic
	always @(cs, intmach.Q_in, intmach.D_in) begin 
		if ( (cs == intmach.WAIT && intmach.D_in == 1'b1) || (cs == intmach.Q_50 && intmach.Q_in == 1'b1) )	
			intmach.dispense = 1'b1;
		else 
			intmach.dispense = 1'b0;

		if (cs == intmach.WAIT && intmach.D_in == 1'b1) 
			intmach.change = 1'b1;
		else	
			intmach.change = 1'b0;
	end

endmodule