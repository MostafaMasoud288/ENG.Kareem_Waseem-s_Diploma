package shift_reg_test_pck;
import shift_reg_env_pck::*;
import shift_reg_config_pck::*;
import shift_sequence_pck::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class shift_reg_test extends uvm_test;

`uvm_component_utils(shift_reg_test);
virtual shift_reg_if shift_reg_vif;
shift_reg_config shift_reg_cfg;
shift_reg_reset_sequence reset_seq;
shift_reg_main_sequence main_seq; 
shift_reg_env env;
function new (string name = "shift_reg_test",uvm_component parent =null);
  super.new(name,parent);
endfunction

function void build_phase (uvm_phase phase);
 super.build_phase(phase);
 env=shift_reg_env::type_id::create("env",this);
 shift_reg_cfg = shift_reg_config::type_id::create("shift_reg_cfg",this);
 reset_seq = shift_reg_reset_sequence::type_id::create("reset_seq",this);
 main_seq = shift_reg_main_sequence::type_id::create("main_seq",this);
  if(!uvm_config_db #(virtual shift_reg_if)::get(this,"","Shift_Reg_If",shift_reg_cfg.shift_reg_vif)) begin
   `uvm_fatal("bulid_phase","Test - Unable to get the virtual interface of the shift_reg from the uvm_config_db") ;end

 uvm_config_db #(shift_reg_config)::set(this,"*","CFG",shift_reg_cfg);
endfunction

task run_phase(uvm_phase phase);
 super.run_phase(phase);
 phase.raise_objection(this);
 `uvm_info("run_phase","reset asserted",UVM_MEDIUM);
  reset_seq.start(env.agt.sqr);
 `uvm_info("run_phase","reset deasserted",UVM_MEDIUM);
`uvm_info("run_phase","stimulas generation started",UVM_MEDIUM);
  main_seq.start(env.agt.sqr);
 `uvm_info("run_phase","stimulas generation started",UVM_MEDIUM);
 phase.drop_objection(this);
endtask

endclass
endpackage 
