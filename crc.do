# vlib ./work
# vmap work ./work

vcom -work work -O0 ./crc.vhd
vsim work.crc(rtl)

add wave *

force -freeze sim:/crc/rst_i 1 0
force -freeze sim:/crc/crc_start_i 0 0
force -freeze sim:/crc/crc_start_i 1 750 ns
force -freeze sim:/crc/data_i 32'hFFFFFFFF 0
force -freeze sim:/crc/clk_i 1 0, 0 {50 ns} -r 100 ns
run

force -freeze sim:/crc/rst_i 0 0
run 6000ns

force -freeze sim:/crc/rst_i 1 0
run 500 ns

radix -hexadecimal
wave zoom full