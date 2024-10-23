package ALSU_test_pck;
import ALSU_env_pck::*;
import ALSU_config_pck::*;
import ALSU_main_sequence_pck::*;
import ALSU_reset_sequence_pck::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class ALSU_test extends uvm_test;

`uvm_component_utils(ALSU_test);
ALSU_env env;
ALSU_config ALSU_cfg;
ALSU_main_sequence_1 main_seq_1;
ALSU_main_sequence_2 main_seq_2;
ALSU_reset_sequence reset_seq;

function new (string name = "ALSU_test",uvm_component parent =null);
  super.new(name,parent);
endfunction

function void build_phase (uvm_phase phase);
 super.build_phase(phase);

 env=ALSU_env::type_id::create("env",this);
 ALSU_cfg = ALSU_config::type_id::create("ALSU_cfg",this);
 main_seq_1 = ALSU_main_sequence_1::type_id::create("main_seq_1",this);
 main_seq_2 = ALSU_main_sequence_2::type_id::create("main_seq_2",this);
 reset_seq = ALSU_reset_sequence::type_id::create("reset_seq",this);
  if(!uvm_config_db #(virtual ALSU_if)::get(this,"","ALSU_If",ALSU_cfg.ALSU_vif)) begin
   `uvm_fatal("bulid_phase","Test - Unable to get the virtual interface of the shift_reg from the uvm_config_db") ;end

 uvm_config_db #(ALSU_config)::set(this,"*","CFG",ALSU_cfg);
endfunction

task run_phase(uvm_phase phase);
 super.run_phase(phase);
 phase.raise_objection(this);
 `uvm_info("run_phase","reset asserted",UVM_MEDIUM);
  reset_seq.start(env.agt.sqr);
 `uvm_info("run_phase","reset deasserted",UVM_MEDIUM);
`uvm_info("run_phase","stimulas generation 1 started",UVM_MEDIUM);
  main_seq_1.start(env.agt.sqr);
 `uvm_info("run_phase","stimulas generation 1 ended",UVM_MEDIUM);
 `uvm_info("run_phase","stimulas generation 2 started",UVM_MEDIUM);
  main_seq_2.start(env.agt.sqr);
 `uvm_info("run_phase","stimulas generation 2 ended",UVM_MEDIUM);
 phase.drop_objection(this);
endtask

endclass
endpackage 
