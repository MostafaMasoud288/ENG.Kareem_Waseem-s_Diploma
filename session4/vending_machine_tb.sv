module vending_machine_tb(vending_machine_interface.test machtest);


	//reset and initial values for inputs
  initial begin
    machtest.rstn = 0;
    machtest.Q_in = 0;
    machtest.D_in = 0;
    #50
   machtest.rstn = 1;
    #100;
        //Test dollars
         machtest.D_in = 1; machtest.Q_in = 0; 
        //Test Quarters 
    #100 machtest.D_in = 0; machtest.Q_in = 1; 
    #100 machtest.D_in = 0; machtest.Q_in = 0;
    #10;

    $stop;
  end


endmodule
