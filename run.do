vlib work
vlog -f src_files.list +cover -covercells
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all
add wave /top/ram_vif/*
add wave -position insertpoint sim:/top/u_dut/*
add wave /top/u_dut/MEM
coverage save tb.ucdb -onexit -du RAM
run -all