package ALSU_env_pck;
import  ALSU_agent_pck::*;
import  ALSU_coverage_pck::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class ALSU_env extends uvm_env;
`uvm_component_utils(ALSU_env)
 ALSU_agent agt ;
 ALSU_coverage cov;
function new (string name = "ALSU_env",uvm_component parent =null);
  super.new(name,parent);
endfunction

function void build_phase (uvm_phase phase);
 super.build_phase(phase);
 agt = ALSU_agent::type_id::create("agt",this);
 cov = ALSU_coverage::type_id::create("cov",this);
endfunction

function void connect_phase (uvm_phase phase);
 agt.agt_ap.connect(cov.cov_export);
endfunction
endclass
endpackage
