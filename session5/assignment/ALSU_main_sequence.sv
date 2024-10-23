package ALSU_main_sequence_pck ;
import uvm_pkg::*;
`include "uvm_macros.svh"
import ALSU_seq_item_pck::*;
class ALSU_main_sequence_1 extends uvm_sequence #(ALSU_seq_item);
 `uvm_object_utils(ALSU_main_sequence_1)
ALSU_seq_item seq_item;

function new (string name = "ALSU_main_sequence_1");
  super.new(name);
endfunction

task body;
repeat(5000) begin
seq_item = ALSU_seq_item::type_id::create("seq_item");
start_item(seq_item);
 seq_item.constraint_mode(0);
 seq_item.ALSU_Cons.constraint_mode(1);
 assert(seq_item.randomize());
finish_item(seq_item); end

endtask
endclass

class ALSU_main_sequence_2 extends uvm_sequence #(ALSU_seq_item);
 `uvm_object_utils(ALSU_main_sequence_2)
ALSU_seq_item seq_item;

function new (string name = "ALSU_main_sequence_2");
  super.new(name);
endfunction

task body;

 for(int i=0;i<500;i++) begin
  seq_item = ALSU_seq_item::type_id::create("seq_item");
  start_item(seq_item);
    seq_item.constraint_mode(0);
    seq_item.extra.constraint_mode(1);
    seq_item.rst=0;seq_item.bypass_A=0;seq_item.bypass_B=0;seq_item.red_op_A=0;seq_item.red_op_B=0;
    seq_item.rst.rand_mode(0);seq_item.bypass_A.rand_mode(0);seq_item.bypass_B.rand_mode(0);seq_item.red_op_A.rand_mode(0);
    seq_item.red_op_B.rand_mode(0);
        assert(seq_item.randomize());
        if(i==28)seq_item.arr.sort();
        foreach(seq_item.arr[j])begin
            seq_item.opcode=seq_item.arr[j];

        end
    
 finish_item(seq_item);
end
endtask
endclass

endpackage