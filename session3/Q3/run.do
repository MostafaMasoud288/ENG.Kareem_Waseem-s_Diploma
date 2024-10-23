vlib work
vlog ram.sv ram_tb2.sv pack.sv  +cover -covercells
vsim -voptargs=+acc work.ram_tb2 -cover
add wave *
coverage save ram_tb2.ucdb -onexit 
run -all
//quit -sim
//vcover report ram_tb2.ucdb -details -all -output coverage_rpt.txt