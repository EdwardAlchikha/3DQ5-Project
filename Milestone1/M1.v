
/*
Copyright by Henry Ko and Nicola Nicolici
Developed for the Digital Systems Design course (COE3DQ4)
Department of Electrical and Computer Engineering
McMaster University
Ontario, Canada
*/

`timescale 1ns/100ps
`default_nettype none

`include "define_state.h"


module M1 (
  input logic Clock,
  input logic Resetn,
  input logic Start,
  output logic Stop,
		
  output logic[17:0]   SRAM_address,
  output logic[15:0]   SRAM_write_data,
  output logic         SRAM_we_n,
  input logic[15:0]    SRAM_read_data
);

logic [17:0] Y_START = 0;
logic [17:0] U_START = 38400;
logic [17:0] V_START = 57600;
logic [17:0] RGB_START = 146944;

logic signed [31:0] mult00, mult01, mult10, mult11, mult20, mult21, mult30, mult31;
logic signed [63:0] MULT0, MULT1, MULT2, MULT3;

always_comb begin
  MULT0 = $signed(mult00 * mult01);
  MULT1 = $signed(mult10 * mult11);
  MULT2 = $signed(mult20 * mult21);
  MULT3 = $signed(mult30 * mult31);
end

logic[7:0] R0, G0, B0, R1, G1, B1, R2, G2, B2, R3, G3, B3;

logic [31:0] Y0, Y1, Y2, Y3,
             U0, U1,
             V0, V1,
             U_0, U_1, U_2, U_3,
             V_0, V_1, V_2, V_3;

enum logic [7:0] {
  IDLE,
  C0, C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11
} STATE;

logic[17:0] ITERATION;

always_ff @(posedge Clock or negedge Resetn) begin
  if(~Resetn) begin
	STATE <= IDLE;
	Stop <= 0;

	R0 <= 0; R1 <= 0; R2 <= 0; R3 <= 0;
	G0 <= 0; G1 <= 0; G2 <= 0; G3 <= 0;
	B0 <= 0; B1 <= 0; B2 <= 0; B3 <= 0;
	Y0 <= 0; Y1 <= 0; Y2 <= 0; Y3 <= 0;
	U0 <= 0; U1 <= 0;
	V0 <= 0; V1 <= 0;
	U_0 <= 0; U_1 <= 0; U_2 <= 0; U_3 <= 0;
	V_0 <= 0; V_1 <= 0; V_2 <= 0; V_3 <= 0;

	mult00 <= 0; mult01 <= 0;
	mult10 <= 0; mult11 <= 0;
	mult20 <= 0; mult21 <= 0;
	mult30 <= 0; mult31 <= 0;
  end
  else begin
	case(STATE)
		IDLE: begin
			SRAM_address <= Y_START;
			SRAM_write_data <= 0;
			SRAM_we_n <= 1;

			ITERATION <= 0;

			if(Start) STATE <= C0;
			else STATE <= IDLE;
		end
		C0: begin
			SRAM_address <= Y_START + (ITERATION << 2);
			SRAM_we_n <= 1;

			STATE <= C1;
		end
		C1: begin
			SRAM_address <= Y_START + 1 + (ITERATION << 2);
			SRAM_we_n <= 1;

			STATE <= C2;
		end
		C2: begin
			SRAM_address <= U_START + ITERATION;
			SRAM_we_n <= 1;

			STATE <= C3;
		end
		C3: begin
			SRAM_address <= V_START + ITERATION;
			SRAM_we_n <= 1;

			STATE <= C4;
		end
		C4: begin
			//IO IDLE
			STATE <= C5;
		end
		C5: begin
			//IO IDLE
			STATE <= C6;
		end
		C6: begin
			STATE <= C7;
		end
		C7: begin
			STATE <= C8;
		end
		C8: begin
			STATE <= C9;
		end
		C9: begin
			STATE <= C10;
		end
		C10: begin
			STATE <= C11;
		end
		C11: begin
			ITERATION <= ITERATION + 1;
			STATE <= C0;
		end
	endcase
  end
end

endmodule