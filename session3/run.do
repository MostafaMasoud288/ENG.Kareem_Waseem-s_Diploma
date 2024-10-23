vlib work
vlog alu.sv testtt.sv funcov.sv  +cover -covercells
vsim -voptargs=+acc work.testtt -cover
add wave *
coverage save testtt.ucdb -onexit 
run -all
///quit -sim
///vcover report testtt.ucdb -details -all -output coverage_rpt.txt