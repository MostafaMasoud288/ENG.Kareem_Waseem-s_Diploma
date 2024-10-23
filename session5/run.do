vlib work
vlog -f src_files.list +cover -covercells
vsim -voptargs=+acc work.shift_reg_top -classdebug -uvmcontrol=all -cover
add wave /shift_reg_top/shift_regif/*
run -all