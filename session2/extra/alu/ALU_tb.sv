package m3;
typedef enum bit [1:0] {ADD,SUB,NOT_A,ReductionOR_B} Opcode_e;

class alu;

rand bit  reset;
rand Opcode_e  Opcode;
rand bit signed [3:0] A, B;
parameter MAXPOS=7,MAXNEG=-8;


constraint c1{reset dist{1:/5,0:/95};}
constraint c2{A dist{MAXPOS:=25,0:=25,MAXNEG:=25};}
constraint c3{B dist{MAXPOS:=25,0:=25,MAXNEG:=25};}
endclass

endpackage




import m3 ::*;
module ALU_tb ();
    logic  clk;
    logic  reset;
    Opcode_e   Opcode;	// The opcode
    logic  signed [3:0] A;	// Input data A in 2's complement
    logic  signed [3:0] B;	// Input data B in 2's complement
reg signed [4:0] 	    Alu_out;

    logic signed [4:0] C,C_exp; // ALU output in 2's complement
 ALU dut(.*);

 integer error_count,correct_count,i;
 alu a = new;

always
begin
clk=0;
#1;
clk=1;
#1;
end
initial
begin 

error_count=0;
correct_count=0;
reset=1;
check_result ;
for(i=0;i<200;i=i+1)
begin
////////
assert(a.randomize());
reset=a.reset;
A=a.A;
B=a.B;
Opcode=a.Opcode;
check_result ;
end
////////
$display(" Number of error transactions %d",error_count);
$display(" Number of correct transactions %d",correct_count);
$stop;
end
  always @* begin
      case (Opcode)
      	2'b00:            Alu_out = A + B;
      	2'b01:            Alu_out = A - B;
      	2'b10:          Alu_out = ~A;
      	2'b11:  Alu_out = |B;
        default:  Alu_out = 5'b0;
      endcase
   end // always @ *

   // Register output C
   always @(posedge clk or posedge reset) begin
      if (reset)
	     C_exp <= 5'b0;
      else
	     C_exp<= Alu_out;
   end


task check_result ;
   @(negedge clk);
 if(C_exp!=C) begin
    $display("incorrect result %t",$time);
    error_count=error_count+1; end
 else
  correct_count=correct_count+1;

endtask

endmodule
