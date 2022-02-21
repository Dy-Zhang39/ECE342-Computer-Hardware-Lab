vlib work
vlog upcount.sv upcountN_tb.sv
vsim -novopt upcountN_tb
log *
add wave *
run -all
