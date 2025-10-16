vlib work
vlog -f src_files.list
vsim -voptargs=+acc work.TB_top -classdebug -uvmcontrol=all
add wave /TB_top/wrap_if/*
add wave -position insertpoint  \
sim:/shared_pkg::seq_select
add wave -position insertpoint  \
sim:/shared_pkg::counter_clk \
sim:/shared_pkg::comm_flag \
sim:/shared_pkg::current_state
add wave -position insertpoint  \
sim:/shared_pkg::MOSI_bits_saved
add wave -position insertpoint  \
sim:/TB_top/DUT_top/rx_data \
sim:/TB_top/DUT_top/rx_valid
add wave -position insertpoint  \
sim:/TB_top/DUT_top/tx_data \
sim:/TB_top/DUT_top/tx_valid
add wave /TB_top/DUT_top/wrapper_sva_inst/assert__stable_MISO
add wave /TB_top/refrence_model/wrapper_sva_inst/assert__stable_MISO
coverage save TB_top.ucdb -onexit 
run -all