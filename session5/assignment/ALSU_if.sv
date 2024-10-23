import uvm_pkg::*;
`include "uvm_macros.svh"
import ALSU_seq_item_pck::* ;
interface ALSU_if (clk);
input clk;
parameter INPUT_PRIORITY = "A";
parameter FULL_ADDER = "ON";
logic signed cin;
logic rst, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
opcode_e opcode;
logic signed [2:0] A, B;
bit [15:0] leds;
bit signed [5:0] out;
endinterface 
