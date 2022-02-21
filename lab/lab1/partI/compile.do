vlib work
vlog rca.sv rca_tb.sv
vsim -novopt tb
log *
add wave *
run -all
