

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

add wave -divider "(U Upsampling)"
add wave -decimal uut/M1_unit/Up8
add wave -decimal uut/M1_unit/Up6
add wave -decimal uut/M1_unit/Up4
add wave -decimal uut/M1_unit/U_3
add wave -decimal uut/M1_unit/Up2
add wave -decimal uut/M1_unit/U_1
add wave -decimal uut/M1_unit/U0
add wave -decimal uut/M1_unit/Un2
add wave -decimal uut/M1_unit/Un4

add wave -divider "(V Upsampling)"
add wave -decimal uut/M1_unit/Vp8
add wave -decimal uut/M1_unit/Vp6
add wave -decimal uut/M1_unit/Vp4
add wave -decimal uut/M1_unit/V_3
add wave -decimal uut/M1_unit/Vp2
add wave -decimal uut/M1_unit/V_1
add wave -decimal uut/M1_unit/V0
add wave -decimal uut/M1_unit/Vn2
add wave -decimal uut/M1_unit/Vn4

#add wave -divider "(Colourspace Conversion)"
#add wave -hexadecimal uut/M1_unit/R0
#add wave -hexadecimal uut/M1_unit/R1
#add wave -hexadecimal uut/M1_unit/R2
#add wave -hexadecimal uut/M1_unit/R3
#add wave -hexadecimal uut/M1_unit/G0
#add wave -hexadecimal uut/M1_unit/G1
#add wave -hexadecimal uut/M1_unit/G2
#add wave -hexadecimal uut/M1_unit/G3
#add wave -hexadecimal uut/M1_unit/B0
#add wave -hexadecimal uut/M1_unit/B1
#add wave -hexadecimal uut/M1_unit/B2
#add wave -hexadecimal uut/M1_unit/B3
