package ALSU_sequencer_pck ;
import uvm_pkg::*;
`include "uvm_macros.svh"
import ALSU_seq_item_pck::*;
class ALSU_sequencer extends uvm_sequencer#(ALSU_seq_item);
 `uvm_component_utils(ALSU_sequencer)

function new (string name = "ALSU_sequencer",uvm_component parent =null);
  super.new(name,parent);
endfunction

endclass
endpackage
