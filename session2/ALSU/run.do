vlib work
vlog ALSU.v ALSU_tb.sv pck.sv   +cover -covercells
vsim -voptargs=+acc work.ALSU_tb -cover
add wave *
coverage save ALSU_tb.ucdb -onexit 
run -all
///coverage exclude -src ALSU.v -line 115 -code b
///coverage exclude -src ALSU.v -line 115 -code s
///quit -sim
///vcover report ALSU_tb.ucdb -details -all -output coverage_rpt.txt