import uvm_pkg::*;
`include "uvm_macros.svh"
interface shift_reg_if (clk);
  input clk;
  logic reset;
  logic serial_in, direction, mode;
  logic [5:0] datain, dataout;
endinterface : shift_reg_if

