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

logic [7:0] Yn4, Yn3, Yn2, Yn1, Y0, Yp1, Yp2, Yp3, Yp4, Yp5, Yp6, Yp7, Yp8, Yp9, Yp10; //8,7,6,5 are always_comb set. Rest always_ff set.
logic [7:0] YP7, YP8, YP9, YP10;
logic [7:0] Un4, Un2, U0, Up2, Up4, Up6, Up8, Up10;
logic [7:0] UP8, UP10;
logic [7:0] Vn4, Vn2, V0, Vp2, Vp4, Vp6, Vp8, Vp10; //Vp10,8 always_comb set, rest always_ff.
logic [7:0] VP8, VP10;

logic [31:0] mult00, mult01, mult10, mult11, mult20, mult21, mult30, mult31;
logic [63:0] MULT0, MULT1, MULT2, MULT3;

logic[7:0] R0, G0, B0, R1, G1, B1, R2, G2, B2, R3, G3, B3;

logic [7:0] U_0, U_1, U_2, U_3,
            V_0, V_1, V_2, V_3;

logic [32:0] DEBUG_SUM_U_1, DEBUG_SUM_U_3;


logic [31:0] U_3B0, U_3B1, U_3B2;
logic [63:0] A11, A21, A31_0, A31_1, A31_2, A31_3;

logic[17:0] ITERATION;

enum logic [7:0] {
  IDLE,
  I0, I1, I2, I3, I4, I5, I6, I7, I8, I9, I10,
  C0, C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11, C12
} STATE;

always_comb begin
  MULT0 = mult00 * mult01;
  MULT1 = mult10 * mult11;
  MULT2 = mult20 * mult21;
  MULT3 = mult30 * mult31;
end

always_comb begin
  YP7 = 0; YP8 = 0; YP9 = 0; YP10 = 0;
  UP8 = 0; UP10 = 0;
  VP8 = 0; VP10 = 0;
  mult00 = 0; mult01 = 0;
  mult10 = 0; mult11 = 0;
  mult20 = 0; mult21 = 0;
  mult30 = 0; mult31 = 0;

  case(STATE)
	C3: begin
		mult00 = 32'd76284;
		mult01 = Y0 - 8'd16;
		mult10 = 32'd76284;
		mult11 = Yp1 - 8'd16;
		
		YP7 = SRAM_read_data[15:8];
		YP8 = SRAM_read_data[7:0];
	end
	C4: begin
		mult20 = 32'd76284;
		mult21 = Yp2 - 8'd16;
		mult30 = 32'd76284;
		mult31 = Yp3 - 8'd16;

		YP9 = SRAM_read_data[15:8];
		YP10 = SRAM_read_data[7:0];
		
	end
	C5: begin
		if((ITERATION % (IMG_WIDTH >> 1)) > ((IMG_WIDTH >> 1) - 3)) begin
			UP8 = Up6;
			UP10 = Up6;
		end
		else begin
			UP8 = SRAM_read_data[15:8];
			UP10 = SRAM_read_data[7:0];
		end

		//For U_1
		mult00 = 32'd21;
		mult01 = Up6 + Un4;
		mult10 = 32'd52;
		mult11 = Up4 + Un2;
		mult20 = 32'd159;
		mult21 = Up2 + U0; //Between p(+)2 and 0, therefore 1.

		//For U_3, buffered.
		mult30 = 32'd21;
		mult31 = UP8 + Un2;
	end
	C6: begin
		if((ITERATION % (IMG_WIDTH >> 1)) > ((IMG_WIDTH >> 1) - 3)) begin
			VP8 = Vp6;
			VP10 = Vp6;
		end
		else begin
			VP8 = SRAM_read_data[15:8];
			VP10 = SRAM_read_data[7:0];
		end

		//For V_1
		mult00 = 32'd21;
		mult01 = Vp6 + Vn4;
		mult10 = 32'd52;
		mult11 = Vp4 + Vn2;
		mult20 = 32'd159;
		mult21 = Vp2 + V0; //Between V+2 and V0, so V_1.
		
		//For U_3, buffered.
		mult30 = 32'd52;
		mult31 = Up6 + U0;
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
		//For V_3
		mult00 = 32'd21;
		mult01 = Vp8 + Vn2;
		mult10 = 32'd52;
		mult11 = Vp6 + V0;
		mult20 = 32'd159;
		mult21 = Vp4 + Vp2; //3 in between.

		//For U_3, buffered.
		mult30 = 32'd159;
		mult31 = Up4 + Up2; //Between 2 and 4, therefore 3.
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


always_ff @(posedge Clock or negedge Resetn) begin
  if(~Resetn) begin
	STATE <= IDLE;
	Stop <= 0;

	R0 <= 0; R1 <= 0; R2 <= 0; R3 <= 0;
	G0 <= 0; G1 <= 0; G2 <= 0; G3 <= 0;
	B0 <= 0; B1 <= 0; B2 <= 0; B3 <= 0;
	U_0 <= 0; U_1 <= 0; U_2 <= 0; U_3 <= 0;
	V_0 <= 0; V_1 <= 0; V_2 <= 0; V_3 <= 0;

	Yn4 <=0; Yn3 <= 0; Yn2 <=0; Yn1 <=0; Y0 <= 0; Yp1 <= 0; Yp2 <= 0; Yp3 <=0; Yp4 <= 0; Yp5 <= 0; Yp6 <= 0; Yp7 <= 0; Yp8 <= 0; Yp9 <= 0; Yp10 <= 0;
	Un4 <=0; Un2 <=0; U0 <= 0; Up2 <= 0; Up4 <=0; Up6 <= 0; Up8 <= 0; Up10 <= 0;
	Vn4 <= 0; Vn2 <= 0; V0 <= 0; Vp2 <=0; Vp4 <= 0; Vp6 <= 0; Vp8 <= 0; Vp10 <=0;
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
			SRAM_we_n <= 1;
			SRAM_address <= U_START + ITERATION;
			STATE <= I1;
		end
		I1: begin
			SRAM_we_n <= 1;
			SRAM_address <= U_START + ITERATION + 1;
			STATE <= I2;
		end
		I2: begin
			SRAM_we_n <= 1;
			SRAM_address <= V_START + ITERATION;
			STATE <= I3;
		end
		I3: begin
			Up2 <= SRAM_read_data[7:0];
			U0 <= SRAM_read_data[15:8];
			Un2 <= SRAM_read_data[15:8];
			Un4 <= SRAM_read_data[15:8];

			SRAM_we_n <= 1;
			SRAM_address <= V_START + ITERATION + 1;
			STATE <= I4;
		end
		I4: begin
			Up4 <= SRAM_read_data[15:8];
			Up6 <= SRAM_read_data[7:0];
			Up8 <= 0;
			Up10 <= 0;

			SRAM_we_n <= 1;
			SRAM_address <= Y_START + (ITERATION << 2);
			STATE <= I5;
		end
		I5: begin
			Vp2 <= SRAM_read_data[7:0];
			V0 <= SRAM_read_data[15:8];
			Vn2 <= SRAM_read_data[15:8];
			Vn4 <= SRAM_read_data[15:8];

			SRAM_we_n <= 1;
			SRAM_address <= Y_START + (ITERATION << 2) + 1;
			STATE <= I6;
		end
		I6: begin
			Vp4 <= SRAM_read_data[15:8];
			Vp6 <= SRAM_read_data[7:0];
			Vp8 <= 0;
			Vp10 <= 0;

			SRAM_we_n <= 1;
			SRAM_address <= Y_START + (ITERATION << 2) + 2;
			STATE <= I7;
		end
		I7: begin
			SRAM_we_n <= 1;
			SRAM_address <= Y_START + (ITERATION << 2) + 3;
			STATE <= I8;
		end
		I8: begin
			STATE <= I9;
		end
		I9: begin
			STATE <= I10;
		end
		I10: begin
			STATE <= C0;
		end
		C0: begin
			SRAM_address <= Y_START + ITERATION*2 + 4; //+4 for the read being +4 addresses (+8 values) ahead.
			SRAM_we_n <= 1;

			STATE <= C1;
		end
		C1: begin
			SRAM_address <= Y_START + 1 + ITERATION*2 + 4;
			SRAM_we_n <= 1;

			STATE <= C2;
		end
		C2: begin
			SRAM_address <= U_START + ITERATION + 2; //+2 for the read being +2 addresses (+4 values) ahead.
			SRAM_we_n <= 1;

			
			STATE <= C3;
		end
		C3: begin
			SRAM_address <= V_START + ITERATION + 2; //+2 for the read being +2 addresses (+4 values) ahead.
			SRAM_we_n <= 1;

			Yp10 <= YP10;
			Yp9 <= YP9;

			A31_0 <= MULT0[31:0];
			A31_1 <= MULT1[31:0];

			STATE <= C4;
		end
		C4: begin
			A31_2 <= MULT2[31:0];
			A31_3 <= MULT3[31:0];
			
			Yp8 <= YP8;
			Yp7 <= YP7;

			STATE <= C5;
		end
		C5: begin
			Up10 <= UP10;
			Up8 <= UP8;

			U_0 <= U0;
			U_1 <= (MULT0 + MULT2 + 32'd128 - MULT1) >> 8;
			U_2 <= Up2;
			
			U_3B0 <= MULT3;

			STATE <= C6;
		end
		C6: begin
			Vp10 <= VP10;
			Vp8 <= VP8;

			V_0 <= V0;
			V_1 <= (MULT0 - MULT1 + MULT2 + 32'd128) >> 8;
			V_2 <= Vp2;

			U_3B1 <= MULT3;

			STATE <= C7;
		end
		C7: begin
			R0 <= (A31_0 + MULT0)/65536;
			G0 <= (A31_0 + MULT1 + MULT2)/65536;
			B0 <= (A31_0 + MULT3)/65536;

			//SRAM_we_n <= 0;
			//SRAM_address <= RGB_START + 0 + ITERATION*6;
			//SRAM_write_data <= {(A31_0 + MULT0)/65536, (A31_0 + MULT1 + MULT2)/65536};

			STATE <= C8;
		end
		C8: begin
			R1 <= (A31_1 + MULT0)/65536;
			G1 <= (A31_1 + MULT1 + MULT2)/65536;
			B1 <= (A31_1 + MULT3)/65536;

			//SRAM_we_n <= 0;
			//SRAM_address <= RGB_START + 1 + ITERATION*6;
			//SRAM_write_data <= {B0, (A31_1 + MULT0)/65536};

			STATE <= C9;
		end
		C9: begin
			U_3B2 <= MULT3; //Not ready for this clock cycle.
			U_3 <= (U_3B0 - U_3B1 + MULT3 + 32'd128) >> 8;
			V_3 <= (MULT0 - MULT1 + MULT2 + 32'd128) >> 8;

			//SRAM_we_n <= 0;
			//SRAM_address <= RGB_START + 2 + ITERATION*6;
			//SRAM_write_data <= {G1, B1};

			STATE <= C10;
		end
		C10: begin
			R2 <= (A31_2 + MULT0)/65536;
			G2 <= (A31_2 + MULT1 + MULT2)/65536;
			B2 <= (A31_2 + MULT3)/65536;

			//SRAM_we_n <= 0;
			//SRAM_address <= RGB_START + 3 + ITERATION*6;
			//SRAM_write_data <= {(A31_2 + MULT0)/65536, (A31_2 + MULT1 + MULT2)/65536};

			STATE <= C11;
		end
		C11: begin
			R3 <= (A31_3 + MULT0)/65536;
			G3 <= (A31_3 + MULT1 + MULT2)/65536;
			B3 <= (A31_3 + MULT3)/65536;

			//SRAM_we_n <= 0;
			//SRAM_address <= RGB_START + 4 + ITERATION*6;
			//SRAM_write_data <= {B2, (A31_3 + MULT0)/65536};

			STATE <= C12;
		end
		C12: begin
			//SRAM_we_n <= 0;
			//SRAM_address <= RGB_START + 5 + ITERATION*6;
			//SRAM_write_data <= {G3, B3};
			Yp10 <= 0; Yp9 <= 0; Yp8 <= 0; Yp7 <= 0; 
			Yp6 <= Yp10; Yp5 <= Yp9; Yp4 <= Yp8; Yp3 <= Yp7; 
			Yp2 <= Yp6; Yp1 <= Yp5; Y0 <= Yp4; Yn1 <= Yp3;
			Yn2 <= Yp2; Yn3 <= Yp1; Yn4 <= Y0;

			Up10 <= 0; Up8 <= 0; 
			Up6 <= Up10; Up4 <= Up8; Up2 <= Up6; U0 <= Up4; Un2 <= Up2; Un4 <= U0;

			Vp10 <= 0; Vp8 <= 0; 
			Vp6 <= Vp10; Vp4 <= Vp8; Vp2 <= Vp6; V0 <= Vp4; Vn2 <= Vp2; Vn4 <= V0;
			

			ITERATION <= ITERATION + 1;

			if(ITERATION % (IMG_WIDTH >> 1) == ((IMG_WIDTH >> 1) - 1)) STATE <= I0; //Downsampled original with WIDTH/2.
			else STATE <= C0;
		end
	endcase
  end
end

endmodule