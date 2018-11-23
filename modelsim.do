vcom -work work -O0 C:/Users/Francis/Desktop/turbo-waffle/crc.vhd
vsim work.crc(rtl)

add wave -position end  sim:/crc/rst_i
add wave -position end  sim:/crc/data_o
add wave -position end  sim:/crc/data_in_reg
add wave -position end  sim:/crc/data_in_aug_reg
add wave -position end  sim:/crc/data_i
add wave -position end  sim:/crc/crc_start_i
add wave -position end  sim:/crc/crc_reg
add wave -position end  sim:/crc/clk_i

force -freeze sim:/crc/rst_i 1 0
force -freeze sim:/crc/data_i 32'h11111111 0
force -freeze sim:/crc/clk_i 1 0, 0 {50 ns} -r 100
run

force -freeze sim:/crc/rst_i 0 0
run 4900ns