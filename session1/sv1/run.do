vlib work
vlog adder.v adder_tbb.svh  +cover -covercells
vsim -voptargs=+acc work.adder_tbb -cover
add wave *
coverage save adder_tbb.ucdb -onexit 
run -all
///quit -sim
///vcover report adder_tbb.ucdb -details -all -output coverage_rpt.txt