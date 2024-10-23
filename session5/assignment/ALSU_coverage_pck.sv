package ALSU_coverage_pck;
import ALSU_seq_item_pck::*;
import ALSU_config_pck::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class ALSU_coverage extends uvm_component;
 `uvm_component_utils(ALSU_coverage)
 uvm_analysis_export #(ALSU_seq_item) cov_export;
 uvm_tlm_analysis_fifo #(ALSU_seq_item) cov_fifo;
 ALSU_seq_item seq_item_cov;

covergroup cvr_grp ;
A_cp1 : coverpoint seq_item_cov.A
{
 bins A_data_0 = {0};
 bins A_data_max = {seq_item_cov.MAXPOS};
 bins A_data_min = {seq_item_cov.MAXNEG};
 bins others = default;
}
A_cp2 : coverpoint seq_item_cov.A iff (seq_item_cov.red_op_A) {bins A_data_walkingones [] = {1,2,4};}

B_cp1 : coverpoint seq_item_cov.B
{
 bins B_data_0 = {0};
 bins B_data_max = {seq_item_cov.MAXPOS};
 bins B_data_min = {seq_item_cov.MAXNEG};
 bins others = default;

}
B_cp2 : coverpoint seq_item_cov.B iff (seq_item_cov.red_op_B && !seq_item_cov.red_op_A) {bins B_data_walkingones [] = {1,2,4};}
ALU_cp : coverpoint seq_item_cov.opcode
{
 bins trans =(OR=>XOR=>ADD=>MULT=>SHIFT=>ROTATE);
 bins shift[] = {SHIFT,ROTATE};
 bins arith[] = {OR,XOR};
 bins bitwise[] = {MULT,ADD};
 //illegal_bins invalid = {INVALID_6,INVALID_7};
}
cin_cp : coverpoint seq_item_cov.cin
{
 bins cin_0 = {0};
  bins cin_1 = {1};

}
serial_in_cp : coverpoint seq_item_cov.serial_in
{
 bins serial_in_0 = {0};
  bins serial_in_1 = {1};

}
direction_cp : coverpoint seq_item_cov.direction
{
 bins direction_0 = {0};
  bins direction_1 = {1};

}

opcode_B: cross ALU_cp,B_cp1
{
 bins op_b1 =binsof(ALU_cp.bitwise)&&binsof(B_cp1.B_data_0);
 bins op_b2 =binsof(ALU_cp.bitwise)&&binsof(B_cp1.B_data_max);
 bins op_b3 =binsof(ALU_cp.bitwise)&&binsof(B_cp1.B_data_min);
 option.cross_auto_bin_max=0;
}
opcode_A: cross ALU_cp,A_cp1
{
 bins op_a1 =binsof(ALU_cp.bitwise)&&binsof(A_cp1.A_data_0);
 bins op_a2 =binsof(ALU_cp.bitwise)&&binsof(A_cp1.A_data_max);
 bins op_a3 =binsof(ALU_cp.bitwise)&&binsof(A_cp1.A_data_min);
 option.cross_auto_bin_max=0;
}
opcode_cin: cross ALU_cp,cin_cp
{
 bins op_cin1 =binsof(ALU_cp.bitwise)&&binsof(cin_cp.cin_0);
 bins op_cin2 =binsof(ALU_cp.bitwise)&&binsof(cin_cp.cin_1);
 option.cross_auto_bin_max=0;
}
opcode_serial: cross ALU_cp,serial_in_cp
{
 bins op_cin1 =binsof(ALU_cp.shift)&&binsof(serial_in_cp.serial_in_0);
 bins op_cin2 =binsof(ALU_cp.shift)&&binsof(serial_in_cp.serial_in_1);
 option.cross_auto_bin_max=0;
}
opcode_direction: cross ALU_cp,direction_cp
{
 bins op_dir1 =binsof(ALU_cp.shift)&&binsof(direction_cp.direction_0);
 bins op_dir2 =binsof(ALU_cp.shift)&&binsof(direction_cp.direction_1);
 option.cross_auto_bin_max=0;
}
endgroup

 function new (string name = "ALSU_coverage",uvm_component parent =null);
  super.new(name,parent);
  cvr_grp=new();
endfunction

function void build_phase (uvm_phase phase);
 super.build_phase(phase);
 cov_export=new("cov_export",this);
 cov_fifo=new("cov_fifo",this);
endfunction

function void connect_phase (uvm_phase phase);
 super.connect_phase(phase);
 cov_export.connect(cov_fifo.analysis_export);
endfunction


task run_phase(uvm_phase phase);
 super.run_phase(phase);
 forever begin
    cov_fifo.get(seq_item_cov);
    cvr_grp.sample();
 end
endtask

endclass 
endpackage