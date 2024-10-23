package mm;
typedef enum {ADD,SUB,MULT,DIV} opcode_e;

class transaction;

rand opcode_e opcode;
rand byte operand1;
rand byte operand2;
bit clk;

covergroup g1  @(posedge clk);
ac:coverpoint opcode
{
  bins opbin1 = {[ADD:SUB]};
  bins opbin2 = (ADD=>SUB);
  illegal_bins opbin3 = {DIV};
 option.weight=0;
}
bc:coverpoint operand1
{
 bins max ={-128};
 bins zero = {0};
 bins min ={127};
 bins others =default;
option.weight=0;
}
cross ac,bc
{
 bins max_addsub =binsof(ac.opbin1) && binsof(bc.max);
 bins min_addsub =binsof(ac.opbin1) && binsof(bc.min);
 option.weight=5;option.cross_auto_bin_max=0;
}
endgroup
function new();
g1=new();
endfunction
endclass
endpackage 
