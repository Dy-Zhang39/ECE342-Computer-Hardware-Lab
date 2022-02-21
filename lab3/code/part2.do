vlib work
vlog part2.sv part2_tb.sv
vsim part2_tb
log *
add wave *
#add wave -position end  sim:/part2_tb/DUT/s_lev
#add wave -position end  sim:/part2_tb/DUT/c_lev
#add wave -position end  sim:/part2_tb/DUT/i
run -all


