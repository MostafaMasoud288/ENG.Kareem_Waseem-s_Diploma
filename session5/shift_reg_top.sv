
import uvm_pkg::*;
`include "uvm_macros.svh"
import shift_reg_test_pck::*;

module shift_reg_top();
bit clk;

initial begin
forever begin
#1 clk=~clk;
end
end

shift_reg_if shift_regif (clk);
shift_reg dut (clk,shift_regif.reset,shift_regif.serial_in,shift_regif.direction,shift_regif.mode,shift_regif.datain,shift_regif.dataout);

initial begin
uvm_config_db #(virtual shift_reg_if)::set(null,"uvm_test_top","Shift_Reg_If",shift_regif);
run_test("shift_reg_test");
end
endmodule

