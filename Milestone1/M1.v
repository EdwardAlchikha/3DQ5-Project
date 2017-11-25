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

logic [7:0] DEBUG_UBUFF [19:0];
logic [7:0] DEBUG_VBUFF [19:0];

logic [17:0] Y_START = 18'd0;
logic [17:0] U_START = 18'd38400;
logic [17:0] V_START = 18'd57600;
logic [17:0] RGB_START = 18'd146944;

logic [15:0] IMG_WIDTH = 16'd320;
logic [15:0] IMG_HEIGHT = 16'd240;

logic [7:0] Y_Buffer [15:0];
logic [7:0] U_Buffer [15:0];
logic [7:0] V_Buffer [15:0];

logic [31:0] mult00, mult01, mult10, mult11, mult20, mult21, mult30, mult31;
logic [63:0] MULT0, MULT1, MULT2, MULT3;

logic[7:0] R0, G0, B0, R1, G1, B1, R2, G2, B2, R3, G3, B3,
           Y0, Y1, Y2, Y3,
           U0, U1,
           V0, V1;

logic [7:0] U_0, U_1, U_2, U_3,
            V_0, V_1, V_2, V_3;

logic [31:0] U_3B0, U_3B1, U_3B2;
logic [63:0] A11, A21, A31_0, A31_1, A31_2, A31_3;

enum logic [7:0] {
  IDLE,
  I0, I1, I2, I3, I4, I5,
  C0, C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11, C12
} STATE;

always_comb begin
  MULT0 = mult00 * mult01;
  MULT1 = mult10 * mult11;
  MULT2 = mult20 * mult21;
  MULT3 = mult30 * mult31;
end

always_comb begin
  Y0 = 0; Y1 = 0; Y2 = 0; Y3 = 0;
  U0 = 0; U1 = 0;
  V0 = 0; V1 = 0;
  mult00 = 0; mult01 = 0;
  mult10 = 0; mult11 = 0;
  mult20 = 0; mult21 = 0;
  mult30 = 0; mult31 = 0;

  case(STATE)
	C3: begin
		mult00 = 32'd76284;
		mult01 = Y_Buffer[11] - 8'd16;
		mult10 = 32'd76284;
		mult11 = Y_Buffer[10] - 8'd16;
		
		Y0 = SRAM_read_data[15:8];
		Y1 = SRAM_read_data[7:0];
	end
	C4: begin
		mult20 = 32'd76284;
		mult21 = Y_Buffer[11] - 8'd16;
		mult30 = 32'd76284;
		mult31 = Y_Buffer[10] - 8'd16;

		Y2 = SRAM_read_data[15:8];
		Y3 = SRAM_read_data[7:0];
		
	end
	C5: begin
		U0 = SRAM_read_data[15:8];
		U1 = SRAM_read_data[7:0];

		mult00 = 32'd21;
		mult01 = U0 + U_Buffer[11];
		mult10 = 32'd52;
		mult11 = U1 + U_Buffer[12];
		mult20 = 32'd159;
		mult21 = U_Buffer[14] + U_Buffer[13];

		mult30 = 32'd21;
		mult31 = U1 + U_Buffer[12];
	end
	C6: begin
		V0 = SRAM_read_data[15:8];
		V1 = SRAM_read_data[7:0];

		mult00 = 32'd21;
		mult01 = V0 + V_Buffer[11];
		mult10 = 32'd52;
		mult11 = V0 + V_Buffer[12];
		mult20 = 32'd159;
		mult21 = V_Buffer[14] + V_Buffer[13];

		mult30 = 32'd52;
		mult31 = U_Buffer[14] + U_Buffer[11]; //Since U0 and U1 were pushed into buffer, not like C5.
	end
	C7: begin
		mult00 = 32'd104595;
		mult01 = V_0 - 32'd128;
		mult10 = 32'd25624;
		mult11 = U_0 - 32'd128;
		mult20 = 32'd53281;
		mult21 = V_0 - 32'd128;
		mult30 = 32'd132251;
		mult31 = U_0 - 32'd128;
	end
	C8: begin
		mult00 = 32'd104595;
		mult01 = V_1 - 32'd128;
		mult10 = 32'd25624;
		mult11 = U_1 - 32'd128;
		mult20 = 32'd53281;
		mult21 = V_1 - 32'd128;
		mult30 = 32'd132251;
		mult31 = U_1 - 32'd128;
	end
	C9: begin
		mult00 = 32'd21;
		mult01 = V_Buffer[15] + V_Buffer[10]; //V1 gone, shifted into buffer. Same goes for below.
		mult10 = 32'd52;
		mult11 = V_Buffer[14] + V_Buffer[11];
		mult20 = 32'd159;
		mult21 = V_Buffer[13] + V_Buffer[12];

		mult30 = 32'd159;
		mult31 = U_Buffer[13] + U_Buffer[12]; //Since U0 and U1 were pushed into buffer, not like C5.
	end
	C10: begin
		mult00 = 32'd104595;
		mult01 = V_2 - 32'd128;
		mult10 = -32'd25624;
		mult11 = U_2 - 32'd128;
		mult20 = -32'd53281;
		mult21 = V_2 - 32'd128;
		mult30 = 32'd132251;
		mult31 = U_2 - 32'd128;
	end
	C11: begin
		mult00 = 32'd104595;
		mult01 = V_3 - 32'd128;
		mult10 = -32'd25624;
		mult11 = U_3 - 32'd128;
		mult20 = -32'd53281;
		mult21 = V_3 - 32'd128;
		mult30 = 32'd132251;
		mult31 = U_3 - 32'd128;
	end
  endcase
end

logic[17:0] ITERATION;

always_ff @(posedge Clock or negedge Resetn) begin
  if(~Resetn) begin
	STATE <= IDLE;
	Stop <= 0;

	R0 <= 0; R1 <= 0; R2 <= 0; R3 <= 0;
	G0 <= 0; G1 <= 0; G2 <= 0; G3 <= 0;
	B0 <= 0; B1 <= 0; B2 <= 0; B3 <= 0;
	U_0 <= 0; U_1 <= 0; U_2 <= 0; U_3 <= 0;
	V_0 <= 0; V_1 <= 0; V_2 <= 0; V_3 <= 0;

	for(int i = 0; i < 16; i++) begin
		Y_Buffer[i] <= 0;
		U_Buffer[i] <= 0;
		V_Buffer[i] <= 0;
	end
  end
  else begin
	case(STATE)
		IDLE: begin
			SRAM_address <= Y_START;
			SRAM_write_data <= 0;
			SRAM_we_n <= 1;

			ITERATION <= 0;

			if(Start) STATE <= I0;
			else STATE <= IDLE;
		end
		I0: begin
			SRAM_address <= Y_START + ITERATION*2;
			SRAM_we_n <= 1;
			STATE <= I1;
		end
		I1: begin
			SRAM_address <= U_START + ITERATION;
			SRAM_we_n <= 1;
			STATE <= I2;
		end
		I2: begin
			SRAM_address <= V_START + ITERATION;
			SRAM_we_n <= 1;
			STATE <= I3;
		end
		I3: begin
			for(int i = 0; i < 15; i++) begin
				Y_Buffer[i] <= SRAM_read_data[15:8];
			end
			Y_Buffer[15] <= SRAM_read_data[7:0];

			STATE <= I4;
		end
		I4: begin
			for(int i = 0; i < 15; i++) begin
				U_Buffer[i] <= SRAM_read_data[15:8];
			end
			U_Buffer[15] <= SRAM_read_data[7:0];

			STATE <= I5;
		end
		I5: begin
			for(int i = 0; i < 15; i++) begin
				V_Buffer[i] <= SRAM_read_data[15:8];
			end
			V_Buffer[15] <= SRAM_read_data[7:0];

			//ITERATION <= ITERATION + 1;
			STATE <= C0;
		end
		C0: begin
			SRAM_address <= Y_START + ITERATION*2;
			SRAM_we_n <= 1;

			STATE <= C1;
		end
		C1: begin
			SRAM_address <= Y_START + 1 + ITERATION*2;
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

			Y_Buffer[15:0] <= {Y1, Y0, Y_Buffer[15:2]};

			A31_0 <= MULT0[31:0];
			A31_1 <= MULT1[31:0];

			STATE <= C4;
		end
		C4: begin
			A31_2 <= MULT2[31:0];
			A31_3 <= MULT3[31:0];
			
			Y_Buffer[15:0] <= {Y3, Y2, Y_Buffer[15:2]};

			STATE <= C5;
		end
		C5: begin
			U_Buffer[15:0] <= {U1, U0, U_Buffer[15:2]};

			U_0 <= U_Buffer[14];
			U_1 <= ((MULT0 + MULT2 + 32'd128) - MULT1)/256;
			U_2 <= U_Buffer[15];
			
			U_3B0 <= MULT3;

			STATE <= C6;
		end
		C6: begin
			V_Buffer[15:0] <= {V1, V0, V_Buffer[15:2]};

			V_0 <= V_Buffer[14];
			V_1 <= (MULT0 - MULT1 + MULT2 + 32'd128) / 256;
			V_2 <= V_Buffer[15];

			U_3B1 <= MULT3;

			STATE <= C7;
		end
		C7: begin
			R0 <= (A31_0 + MULT0)/65536;
			G0 <= (A31_0 + MULT1 + MULT2)/65536;
			B0 <= (A31_0 + MULT3)/65536;

			SRAM_we_n <= 0;
			SRAM_address <= RGB_START + 0 + ITERATION*6;
			SRAM_write_data <= {(A31_0 + MULT0)/65536, (A31_0 + MULT1 + MULT2)/65536};

			STATE <= C8;
		end
		C8: begin
			R1 <= (A31_1 + MULT0)/65536;
			G1 <= (A31_1 + MULT1 + MULT2)/65536;
			B1 <= (A31_1 + MULT3)/65536;

			SRAM_we_n <= 0;
			SRAM_address <= RGB_START + 1 + ITERATION*6;
			SRAM_write_data <= {B0, (A31_1 + MULT0)/65536};

			STATE <= C9;
		end
		C9: begin
			U_3B2 <= MULT3; //Not ready for this clock cycle.
			U_3 <= (U_3B0 - U_3B1 + MULT3 + 32'd128)/256;
			V_3 <= (MULT0 - MULT1 + MULT2 + 32'd128)/256;

			SRAM_we_n <= 0;
			SRAM_address <= RGB_START + 2 + ITERATION*6;
			SRAM_write_data <= {G1, B1};

			STATE <= C10;
		end
		C10: begin
			DEBUG_UBUFF[19:0] <= {U_3, U_2, U_1, U_0, DEBUG_UBUFF[19:4]};

			R2 <= (A31_2 + MULT0)/65536;
			G2 <= (A31_2 + MULT1 + MULT2)/65536;
			B2 <= (A31_2 + MULT3)/65536;

			SRAM_we_n <= 0;
			SRAM_address <= RGB_START + 3 + ITERATION*6;
			SRAM_write_data <= {(A31_2 + MULT0)/65536, (A31_2 + MULT1 + MULT2)/65536};

			STATE <= C11;
		end
		C11: begin
			R3 <= (A31_3 + MULT0)/65536;
			G3 <= (A31_3 + MULT1 + MULT2)/65536;
			B3 <= (A31_3 + MULT3)/65536;

			SRAM_we_n <= 0;
			SRAM_address <= RGB_START + 4 + ITERATION*6;
			SRAM_write_data <= {B2, (A31_3 + MULT0)/65536};

			STATE <= C12;
		end
		C12: begin
			SRAM_we_n <= 0;
			SRAM_address <= RGB_START + 5 + ITERATION*6;
			SRAM_write_data <= {G3, B3};

			ITERATION <= ITERATION + 1;

			if(ITERATION == (IMG_WIDTH / 2 - 1)) STATE <= I0; //Downsampled original with WIDTH/2.
			else STATE <= C0;
		end
	endcase
  end
end

endmodule