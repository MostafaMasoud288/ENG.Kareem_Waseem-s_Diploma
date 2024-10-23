vlib work
vlog vending_machine_top.sv  +cover -covercells
vsim -voptargs=+acc work.vending_machine_top -cover
add wave *
coverage save vending_machine_top.ucdb -onexit 
run -all
//quit -sim
//vcover report ram_tb2.ucdb -details -all -output coverage_rpt.txt