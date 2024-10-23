vlib work
vlog ALU.v ALU_tb.sv  +cover -covercells
vsim -voptargs=+acc work.ALU_tb -cover
add wave *
coverage save ALU_tb.ucdb -onexit -du work.ALU
run -all
///coverage exclude -src ALU.v -line 26 -code s//exclution for default case as it will never happen
///quit -sim
///vcover report ALU_tb.ucdb -details -all -output coverage_rpt.txt