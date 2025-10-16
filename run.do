vlib work
vlog -f src_files.list +define+SIM 
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all 
add wave /top/SPI_Slave_vif/*
add wave -position insertpoint \
sim:/shared_pkg::counter_clk \
sim:/shared_pkg::comm_flag \
sim:/shared_pkg::current_state \
sim:/shared_pkg::MOSI_bits_saved
coverage save top.ucdb -onexit
run -all





