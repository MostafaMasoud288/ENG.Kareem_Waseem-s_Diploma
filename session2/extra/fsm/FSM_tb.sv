package FSM_Package;

// Enums //
typedef enum bit [1:0] {IDLE=0,ZERO,ONE,STORE} state_e;

// Class //
class fsm_transaction;

// Class Variables //
rand bit  rst, x;
bit clk ;

// Constraints block //

constraint fsm_Cons {

    //Reset to be asserted with a low probability//
    rst dist {1:=1,0:=99}; 
    //x must be 0 67% of the time
    x dist {1:=33,0:=67};
}
covergroup g @(posedge clk);
coverpoint x{bins data_010 = (0=>1=>0);}
endgroup
function new;
g=new;
endfunction

endclass

endpackage

import FSM_Package::*;
module FSM_tb();
	bit clk, rst, x;
	bit y,y_exp;
	bit [9:0] users_count,users_count_exp;

	state_e  cs, ns;
 FSM_010 dut(.*);

 integer error_count,correct_count,i;
 fsm_transaction a = new;

initial
begin
clk=0;
forever begin
#1 clk=~clk;
a.clk=clk;
end

end

initial
begin 

error_count=0;
correct_count=0;
rst=1;
check_result ;
for(i=0;i<5000;i=i+1)
begin
////////
assert(a.randomize());
rst=a.rst;
x=a.x;
check_result ;
end
////////
$display(" Number of error transactions %d",error_count);
$display(" Number of correct transactions %d",correct_count);
$stop;
end
task check_result ;
   @(negedge clk);
 if(y_exp!=y || users_count!=users_count_exp) begin
    $display("incorrect result %t",$time);
    error_count=error_count+1;
 end
 else
  correct_count=correct_count+1;

endtask

	always @(*) begin
		case (cs)
			IDLE: begin
                                y_exp=0;
				if (x)
					ns = IDLE;
				else 
					ns = ZERO; end
			ZERO:begin
                                 y_exp=0;
				if (x)
					ns = ONE;
				else 
					ns = ZERO;end
			ONE: begin
                                y_exp=0;
				if (x)
					ns = IDLE;
				else 
					ns = STORE;end
			STORE: begin
                                y_exp=1;
				if (x)
					ns = IDLE;
				else 
					ns = ZERO;end
			default: 	ns = IDLE;
		endcase
	end

	always @(posedge clk or posedge rst) begin
		if(rst) begin
			cs <= IDLE;
		end
		else begin
			cs <= ns;
		end
	end

	always @(posedge clk or posedge rst) begin
		if(rst) begin
			users_count_exp <= 0;
		end
		else begin
			if (cs==STORE)
				users_count_exp <= users_count_exp + 1;
		end
	end
endmodule

