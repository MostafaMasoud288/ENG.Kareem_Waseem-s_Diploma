vlib work
vlog counter_top.sv counter.sv counter_tb.sv counter_sva.sv counter_interface.sv pack.sv +cover -covercells
vsim -voptargs=+acc work.counter_top -cover
add wave *
coverage save counter_top.ucdb -onexit 
run -all
//quit -sim
//vcover report counter_top.ucdb -details -all -output coverage_rpt.txt