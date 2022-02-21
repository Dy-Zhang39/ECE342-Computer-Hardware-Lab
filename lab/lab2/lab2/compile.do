vlib work
vlog elevator.sv elevator_tb.sv
vsim -novopt elevator_tb
log *
add wave *
run -all
