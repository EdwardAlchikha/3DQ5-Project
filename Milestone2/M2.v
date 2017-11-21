`timescale 1ns/100ps
`default_nettype none

`include "define_state.h"


module M2 (
	input logic Clock,
	input logic Resetn,
	input logic       Start,
	output logic       Stop,
		
	 output logic[17:0]   SRAM_address,
  	output logic[15:0]   SRAM_write_data,
  	output logic         SRAM_we_n,
  	input logic[15:0]    SRAM_read_data
);

logic [8:0] Y_pixel, U_pixel, V_pixel, S_dp;
logic [17:0] Y_offset, U_offset, V_offset, row;

logic [6:0] read_address, write_address;
logic [31:0] write_data_b [1:0];
logic write_enable_b [1:0];
logic [31:0] read_data_a [1:0];
logic [31:0] read_data_b [1:0];
logic signed [31:0] Cop;

assign Y_offset = 76800;
assign U_offset = 153600;
assign V_offset = 192000;

// Instantiate RAM1
dual_port_RAM1 dual_port_RAM_inst1 (
	.address_a ( read_address ),
	.address_b ( write_address ),
	.clock ( Clock ),
	.data_a ( 32'd0 ),
	.data_b ( write_data_b[1] ),
	.wren_a ( 1'b0 ),
	.wren_b ( write_enable_b[1] ),
	.q_a ( read_data_a[1] ),
	.q_b ( read_data_b[1] )
	);

// Instantiate RAM0
dual_port_RAM0 dual_port_RAM_inst0 (
	.address_a ( read_address ),
	.address_b ( write_address ),
	.clock ( Clock ),
	.data_a ( 32'd0 ),
	.data_b ( write_data_b[0] ),
	.wren_a ( 1'b0 ),
	.wren_b ( write_enable_b[0] ),
	.q_a ( read_data_a[0] ),
	.q_b ( read_data_b[0] )
	);

enum logic[6:0]{

  IDLE,
  delay,
  LI0,
  LI1,
  LI2,
  LI3

}state;

always @(posedge Clock or negedge Resetn) begin
	if (~Resetn) begin
	  Y_pixel <= 0;
    U_pixel <= 0;
    V_pixel <= 0;
    S_dp <= 0;	  
	  row <= 0;
	  
	  write_enable_b[0] <= 0;
	  SRAM_we_n <= 1'b1;
	  SRAM_write_data <= 16'd0;
	  SRAM_address <= 18'd0;
	  state <= IDLE;
	  Stop <= 1'b0;

  end else begin
	   case(state)
	 IDLE: begin                                        
	   if(Start)begin
	     state<= delay;
	   end
	 end
	 delay: begin
	   SRAM_we_n <= 1;
	   SRAM_address <= Y_offset + Y_pixel;
	   Y_pixel <= Y_pixel + 1;
	   state <= LI0;
	 end
	 LI0: begin
	   SRAM_address <= Y_offset + Y_pixel;
	   Y_pixel <= Y_pixel + 1;
	   state <= LI1;
	 end
	 LI1: begin
	   if(Y_pixel < 7 && S_dp < 64)begin
	     Y_pixel <= + Y_pixel + 1;
	     write_enable_b[0] <= 1;
	     SRAM_address <= Y_offset + Y_pixel + row;
	     write_data_b[0] <= SRAM_read_data;
	     write_address <= S_dp;
	     S_dp <= S_dp + 1;
	     
	     state <= LI1;
	   end else if (Y_pixel >= 7 && S_dp <64)begin
	     Y_pixel <= 0;
	     row <= row + 320;
	     SRAM_address <= Y_offset + Y_pixel + row;
	     write_enable_b[0] <= 1;
	     write_data_b[0] <= SRAM_read_data;
	     write_address <= S_dp;
	     S_dp <= S_dp + 1;
	     state <= LI1;
	   end else begin
	     S_dp <= 64;
	     state <= LI2;
	   end
	   end
	   LI2: begin
	     write_enable_b[0] <= 0;
	     if(S_dp < 128)begin
	       S_dp <= 1 + S_dp;
	       write_address <= S_dp;
	       write_enable_b[0] <= 0;
	       state <= LI2;
	     end else begin
	       SRAM_we_n <= 1;
	       Stop <= 1;
	     end  
	     
	  end
	  endcase
	 end  
  end
endmodule