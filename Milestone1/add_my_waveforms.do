

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

add wave -divider "(M1 Values)"
add wave -hexadecimal uut/M1_unit/Y0
add wave -hexadecimal uut/M1_unit/Y1
add wave -hexadecimal uut/M1_unit/Y2
add wave -hexadecimal uut/M1_unit/Y3
add wave -hexadecimal uut/M1_unit/U0
add wave -hexadecimal uut/M1_unit/U1
add wave -hexadecimal uut/M1_unit/V0
add wave -hexadecimal uut/M1_unit/V1

add wave -divider "(Upsampling)"
add wave -hexadecimal uut/M1_unit/U_0
add wave -hexadecimal uut/M1_unit/U_1
add wave -hexadecimal uut/M1_unit/U_2
add wave -hexadecimal uut/M1_unit/U_3
add wave -hexadecimal uut/M1_unit/V_0
add wave -hexadecimal uut/M1_unit/V_1
add wave -hexadecimal uut/M1_unit/V_2
add wave -hexadecimal uut/M1_unit/V_3

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

add wave -divider "(Read Buffers)"
add wave -hexadecimal uut/M1_unit/Y_Buffer
add wave -hexadecimal uut/M1_unit/U_Buffer
add wave -hexadecimal uut/M1_unit/V_Buffer

add wave -divider "(M1 Buffers)"
add wave -hexadecimal uut/M1_unit/A31_0
add wave -hexadecimal uut/M1_unit/A31_1
add wave -hexadecimal uut/M1_unit/A31_2
add wave -hexadecimal uut/M1_unit/A31_3
add wave -hexadecimal uut/M1_unit/U_3B0
add wave -hexadecimal uut/M1_unit/U_3B1
add wave -hexadecimal uut/M1_unit/U_3B2
add wave -hexadecimal uut/M1_unit/DEBUG_UBUFF

