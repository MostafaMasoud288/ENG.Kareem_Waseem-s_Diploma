package sequencer ;
import uvm_pkg::*;
`include "uvm_macros.svh"
import sequence_item::*;
class mysequencer extends uvm_sequencer#(shift_reg_seq_item);
 `uvm_component_utils(mysequencer)

function new (string name = "mysequencer",uvm_component parent =null);
  super.new(name,parent);
endfunction

endclass
endpackage
