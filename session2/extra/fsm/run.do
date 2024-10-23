vlib work
vlog FSM_010.v FSM_tb.sv  +cover -covercells
vsim -voptargs=+acc work.FSM_tb -cover
add wave *
coverage save FSM_tb.ucdb -onexit 
run -all
//coverage exclude -du FSM_010 -togglenode {users_count[7]}
//////exclution as it would take so mant test cases to cover all 10bits which is not necessary
//coverage exclude -du FSM_010 -togglenode {users_count[8]}
//coverage exclude -du FSM_010 -togglenode {users_count[9]}
///quit -sim
///vcover report FSM_tb.ucdb -details -all -output coverage_rpt.txt