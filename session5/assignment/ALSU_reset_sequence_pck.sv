package ALSU_reset_sequence_pck ;
import uvm_pkg::*;
`include "uvm_macros.svh"
import ALSU_seq_item_pck::*;
class ALSU_reset_sequence extends uvm_sequence #(ALSU_seq_item);
 `uvm_object_utils(ALSU_reset_sequence)
ALSU_seq_item seq_item;

function new (string name = "ALSU_reset_sequence");
  super.new(name);
endfunction

task body;
seq_item = ALSU_seq_item::type_id::create("seq_item");
start_item(seq_item);
seq_item.rst=1'b1;
finish_item(seq_item);
endtask

endclass
endpackage