vlib work
vlog part1.sv part1_tb.sv
vsim part1_tb
log *
add wave *
add wave -position end  sim:/part1_tb/DUT/pp
add wave -position end  sim:/part1_tb/DUT/loop2\[1\]/loop3\[2\]/my_full_adder/cin
add wave -position end  sim:/part1_tb/DUT/loop2\[1\]/loop3\[2\]/my_full_adder/x
add wave -position end  sim:/part1_tb/DUT/loop2\[1\]/loop3\[2\]/my_full_adder/y
add wave -position end  sim:/part1_tb/DUT/loop2\[1\]/loop3\[2\]/my_full_adder/cout
add wave -position end  sim:/part1_tb/DUT/loop2\[1\]/loop3\[2\]/my_full_adder/s
add wave -position end  sim:/part1_tb/DUT/cin
run -all


