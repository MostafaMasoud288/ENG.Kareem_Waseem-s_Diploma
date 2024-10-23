import mm ::*;
module testtt();
 byte operand1, operand2;
bit clk, rst;
 opcode_e opcode;
 byte out;
integer i;
alu_seq dut (operand1, operand2, clk, rst, opcode, out);
transaction obj=new;


initial
begin
clk=0;
forever begin  
#1 clk=~clk;
obj.clk=clk;
end
end

initial begin
rst=1;
@(negedge clk);
rst=0;
for( i=0;i<1000;i++)begin
assert(obj.randomize());
 operand1=obj.operand1;
 operand2=obj.operand2;
opcode=obj.opcode;
@(negedge clk);
end 
$stop;
end


endmodule