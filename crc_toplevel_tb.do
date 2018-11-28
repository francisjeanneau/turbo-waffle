# vlib ./work
# vmap work ./work

vcom -work work -O0 ./crc.vhd
vcom -work work -O0 ./deserializer.vhd
vcom -work work -O0 ./serializer.vhd
vcom -work work -O0 ./crc_controller.vhd
vcom -work work -O0 ./toplevel.vhd
vcom -work work -O0 ./crc_toplevel_tb.vhd

vsim work.crc_toplevel_tb

add wave -depth 3 *

run 60000 ns
wave zoom full
wave zoom range 13000 15000