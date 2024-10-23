package aluuu;
class transaction;
    rand bit  reset;
    rand bit  [1:0] Opcode;
    rand bit  signed [3:0] A;	
    rand bit signed [3:0] B;	
localparam MAXPOS= 7,MAXNEG= -8 ;
constraint cons {
reset dist {1:/5,0:/95};
A dist {MAXPOS:/20,0:/20,MAXNEG:/20,[1:6]:/20,[-7:-1]:/20};
B dist {MAXPOS:/20,0:/20,MAXNEG:/20,[1:6]:/20,[-7:-1]:/20};
}
endclass
endpackage

import aluuu::*;
module ALU_tb ();
    logic  clk;
    logic  reset;
    logic  [1:0] Opcode;	// The opcode
    logic  signed [3:0] A;	// Input data A in 2's complement
    logic  signed [3:0] B;	// Input data B in 2's complement

    logic signed [4:0] C; // ALU output in 2's complement
 ALU alu(.*);
 transaction tra =new;

always
begin
clk=0;
#5;
clk=1;
#5;
end

property rst;
@(negedge clk or posedge reset) reset |-> (C==0);
endproperty

property addition;
@(negedge clk) (!reset&&Opcode==0) |-> (C==A+B);
endproperty

property subtraction;
@(negedge clk) (!reset&&Opcode==1) |-> (C==A-B);
endproperty

property invert_A;
@(negedge clk) (!reset&&Opcode==2) |-> (C==~A);
endproperty

property red_or_B;
@(negedge clk) (!reset&&Opcode==3) |-> (C==|B);
endproperty


assert property (rst);
cover property (rst);
assert property (addition);
cover property (addition);
assert property (subtraction);
cover property (subtraction);
assert property (invert_A);
cover property (invert_A);
assert property (red_or_B);
cover property (red_or_B);
initial
begin 
for(int i=0 ;i<5000;i++)begin
randomization:assert(tra.randomize());
reset=tra.reset;
Opcode=tra.Opcode;
A=tra.A;
B=tra.B;
@(negedge clk);
#1;
end
$stop;
end

endmodule
