import uvm_pkg::*;
`include "uvm_macros.svh"
import ALSU_test_pck::*;

module ALSU_top();
bit clk;

initial begin
forever begin
#1 clk=~clk;
end
end

ALSU_if ALSUif (clk);
ALSU #(ALSUif.INPUT_PRIORITY,ALSUif.FULL_ADDER) dut (.clk(clk),.rst(ALSUif.rst), .cin(ALSUif.cin), .red_op_A(ALSUif.red_op_A),
 .red_op_B(ALSUif.red_op_B),.bypass_A(ALSUif.bypass_A), .bypass_B(ALSUif.bypass_B), .direction(ALSUif.direction),
  .serial_in(ALSUif.serial_in),.opcode(ALSUif.opcode),.A(ALSUif.A),.B(ALSUif.B),.leds(ALSUif.leds),.out(ALSUif.out));

bind ALSU ALSU_assertions #(INPUT_PRIORITY,FULL_ADDER) INIT (.clk(clk),.rst(rst), .cin(cin), .red_op_A(red_op_A), .red_op_B(red_op_B),
 .bypass_A(bypass_A), .bypass_B(bypass_B), .direction(direction), .serial_in(serial_in),.opcode(opcode),.A(A),.B(B),.leds(leds),.out(out));
initial begin
uvm_config_db #(virtual ALSU_if)::set(null,"uvm_test_top","ALSU_If",ALSUif);
run_test("ALSU_test");
end
endmodule

