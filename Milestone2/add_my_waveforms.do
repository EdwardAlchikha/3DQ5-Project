

# add waves to waveform
add wave Clock_50
add wave -divider {Top level signals}
add wave uut/top_state
add wave uut/M1_start
add wave uut/M1_stop
add wave uut/M2_start
add wave uut/M2_stop

add wave -divider {SRAM signals}
add wave uut/SRAM_we_n
add wave -hexadecimal uut/SRAM_write_data
#add wave -decimal uut/M1_unit/r_flag
#add wave -decimal uut/M1_unit/UV_val
add wave -decimal uut/M1_unit/row
add wave -hexadecimal uut/SRAM_read_data
add wave -unsigned uut/SRAM_address

add wave -divider {Milestone 2 signals}

add wave uut/M2_unit/state
add wave -unsigned uut/M2_unit/write_address
add wave -decimal uut/M2_unit/write_data_b
add wave -decimal uut/M2_unit/read_data_b
add wave -decimal uut/M2_unit/write_enable_b
add wave -decimal uut/M2_unit/Y_pixel
add wave -decimal uut/M2_unit/U_pixel
add wave -decimal uut/M2_unit/V_pixel
add wave -decimal uut/M2_unit/S_dp
add wave -decimal uut/M2_unit/row


add wave -divider {Milestone 1 signals}
add wave uut/M1_unit/state

add wave -divider {}
add wave -hexadecimal uut/M1_unit/reg_Y0
add wave -hexadecimal uut/M1_unit/reg_Y1
add wave -hexadecimal uut/M1_unit/reg_Y2
add wave -hexadecimal uut/M1_unit/reg_Y3
add wave -hexadecimal uut/M1_unit/reg_Y4
add wave -hexadecimal uut/M1_unit/reg_Y5

add wave -divider {}
add wave -hexadecimal uut/M1_unit/reg_U0
add wave -hexadecimal uut/M1_unit/reg_U1
add wave -hexadecimal uut/M1_unit/reg_U2
add wave -hexadecimal uut/M1_unit/reg_U3
add wave -hexadecimal uut/M1_unit/reg_U4
add wave -hexadecimal uut/M1_unit/reg_U5

add wave -divider {}
add wave -hexadecimal uut/M1_unit/reg_V0
add wave -hexadecimal uut/M1_unit/reg_V1
add wave -hexadecimal uut/M1_unit/reg_V2
add wave -hexadecimal uut/M1_unit/reg_V3
add wave -hexadecimal uut/M1_unit/reg_V4
add wave -hexadecimal uut/M1_unit/reg_V5

add wave -divider {}
add wave -hexadecimal uut/M1_unit/U_p
add wave -hexadecimal uut/M1_unit/V_p

add wave -divider {}
add wave -hexadecimal uut/M1_unit/M4
add wave -hexadecimal uut/M1_unit/M5
add wave -hexadecimal uut/M1_unit/M6
add wave -hexadecimal uut/M1_unit/M1
add wave -hexadecimal uut/M1_unit/M2
add wave -hexadecimal uut/M1_unit/M3
add wave -hexadecimal uut/M1_unit/hold_G
add wave -hexadecimal uut/M1_unit/hold_B


add wave -divider {}
add wave -hexadecimal uut/M1_unit/op1
add wave -hexadecimal uut/M1_unit/op2
add wave -hexadecimal uut/M1_unit/op3
add wave -hexadecimal uut/M1_unit/op4
add wave -hexadecimal uut/M1_unit/op5
add wave -hexadecimal uut/M1_unit/op6


add wave -divider {}
add wave -hexadecimal uut/M1_unit/R
add wave -hexadecimal uut/M1_unit/G
add wave -hexadecimal uut/M1_unit/B