

# add waves to waveform
add wave Clock_50
#add wave -divider {Top level signals}
#add wave uut/top_state
#add wave uut/M1_start
#add wave uut/M1_stop

#add wave -divider {SRAM signals}
add wave uut/SRAM_we_n
add wave -hexadecimal uut/SRAM_write_data
add wave  uut/M1_unit/STATE
add wave -hexadecimal uut/SRAM_read_data
add wave -unsigned uut/SRAM_address
