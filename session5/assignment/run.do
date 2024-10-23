vlib work
vlog -f src_files.list +cover -covercells
vsim -voptargs=+acc work.ALSU_top -classdebug -uvmcontrol=all -cover
add wave /ALSU_top/ALSUif/*
coverage save ALSU_top.ucdb -onexit 
run -all
//quit -sim
//vcover report ALSU_top.ucdb -details -all -output coverage_rpt.txt