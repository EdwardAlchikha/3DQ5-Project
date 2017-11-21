
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
	input logic       Start,
	output logic       Stop,
		
	output logic[17:0]   SRAM_address,
	output logic[15:0]   SRAM_write_data,
 	output logic         SRAM_we_n,
 	input logic[15:0]    SRAM_read_data
);
	
//M1 code
logic r_flag;   // to only read one U and V value

logic [31:0] reg_U0,reg_U1,reg_U2,reg_U3,reg_U4,reg_U5,
            reg_V0,reg_V1,reg_V2,reg_V3,reg_V4,reg_V5,
            reg_Y0,reg_Y1,reg_Y2,reg_Y3,reg_Y4,reg_Y5;
            
logic signed [31:0] M1, M2, M3, hold_G, hold_B;

logic signed [63:0] M4, M5, M6;

logic [7:0] R, G, B;

logic signed [31:0] R1, B1, G1;
 
logic[9:0] row;

logic signed [7:0] U_p, V_p;

logic[17:0]  U_offset, V_offset, RGB_offset;
logic[17:0]  UV_val, ypixel, upixel, vpixel, RGBpixel;
logic signed [31:0] a00, a02, a11, a12, a21; 

assign U_offset = 38400;
assign V_offset = 57600;
assign RGB_offset = 146944;

logic signed [31:0] op1,op2,op3,op4,op5,op6;

assign R1 = M1 + M2;
assign G1 = hold_G + M2;
assign B1 = hold_B + M3;

assign a00 = 32'd76284;
assign a02 = 32'd104595;
assign a11 = -32'd25624;
assign a12 = -32'd53281;
assign a21 = 32'd132251;


enum logic [10:0]{
    delay,
    IDLE,
    LI,
    LI0,
    LI1,
    LI2,
    LI3,
    LI4,
    LI5,
    LI6,
    LI7,
    LI8,
    LI9,
    LI10,
    LI11,
    LI12,
    LI13,
    LI14,
    LI15,
    LI16,
    LI17,
    LI18,
    LI19,
    LI20,
    LI21,
    LI22,
    LI23,
    LI24,
    LI25,
    LI26,
    
    CC0,
    CC1,
    CC2,
    CC3,
    CC4,
    CC5,
    CC6,
    CC7,
    CC8,
    CC9,
    
   
    LO0,
    LO1,
    LO2,
    LO3,
    LO4,
    LO5,
    LO6,
    LO7,
    LO8,
    LO9,
    LO10,
    LO11,
    LO12,
    LO13,
    LO14,
    LO15,
    LO16,
    LO17,
    LO18,
    LO19,
    LO20,
    LO21,
    LO22,
    LO23,
    LO24,
    finish_M1
    
} state;

assign M1 = M4[31:0];
assign M2 = M5[31:0];
assign M3 = M6[31:0];

assign M4 = op1*op2;
assign M5 = op3*op4;
assign M6 = op5*op6;

always @(posedge Clock or negedge Resetn) begin
	if (~Resetn) begin
	    
	    RGBpixel  <= 0;
	    ypixel    <= 0;
	    upixel    <= 0;
	    vpixel    <= 0;
	    
	    op1 <= 0; 
	    op2 <= 0;
      op3 <= 0;
      op4 <= 0;
      op5 <= 0;
      op6 <= 0;
	         
	    UV_val <= 0;
	    r_flag <= 1; 
	    row = 0;
	    reg_Y0 <= 0;     
      reg_Y1 <= 0;
      reg_Y2 <= 0;
      reg_Y3 <= 0;
      reg_Y4 <= 0;
	    reg_Y5 <= 0;
	    
	    reg_U0 <= 0;     
      reg_U1 <= 0;
      reg_U2 <= 0;
      reg_U3 <= 0;
      reg_U4 <= 0;
	    reg_U5 <= 0;
	    
	    reg_V0 <= 0;     
      reg_V1 <= 0;
      reg_V2 <= 0;
      reg_V3 <= 0;
      reg_V4 <= 0;
	    reg_V5 <= 0;
	  
	    R <= 0;
	    G <= 0;
	    B <= 0;
	    
	    U_p <= 0;
	    V_p <= 0;
	   
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
	 //Read Y0Y1 from memory (not in registers yet)
	 delay: begin
	   SRAM_we_n <= 1;
	   SRAM_address <= ypixel;               
	   ypixel <= ypixel + 1; 
	   state <= LI0;  
	   
	 end
	 //Read Y2Y3 from memory (not in registers yet)
	 LI0: begin                              
	   SRAM_address <= ypixel;               
	   ypixel <= ypixel + 1;                 
	   state <= LI1;                         
	 end               
	 //Read Y4Y5 from memory (not in registers yet)                      
	 LI1: begin                              
	   SRAM_address <= ypixel;//read y4y5
	   ypixel    <= ypixel + 1;
	   state <= LI2;
	 end
	 //Shift Y0Y1 into registers, read U0U1
	 LI2: begin                               
	   reg_Y5 <= SRAM_read_data[7:0];
	   reg_Y4 <= SRAM_read_data[15:8];
	   SRAM_address <= U_offset + upixel;    
	   upixel <= upixel +1;
	   state <= LI3;
	   end
	 //Shift in Y2Y3 into registers, read U2U3
	 LI3: begin
	   reg_Y5 <= SRAM_read_data[7:0];
	   reg_Y4 <= SRAM_read_data[15:8];
	   reg_Y3 <= reg_Y5;
	   reg_Y2 <= reg_Y4;
	   
	   SRAM_address <= U_offset + upixel; 
	   upixel <= upixel + 1;
	   state <= LI4;
	   end
	 //Shift in Y4Y5 into registers, read U4U5
	 LI4: begin                                   
	   reg_Y5 <= SRAM_read_data[7:0]; 
	   reg_Y4 <= SRAM_read_data[15:8];
	   reg_Y3 <= reg_Y5;
	   reg_Y2 <= reg_Y4;
	   reg_Y1 <= reg_Y3;
	   reg_Y0 <= reg_Y2;
	   
	   SRAM_address <= U_offset + upixel;
	   upixel <= upixel +1;                             
	   state <= LI5;
	   end
	 //Shift in U0U1 into registers, read V0V1
	 LI5: begin                                    
	   reg_U5 <= SRAM_read_data[7:0];        
	   reg_U4 <= SRAM_read_data[15:8];
	  
	   SRAM_address <= V_offset + vpixel;                 
	   vpixel <= vpixel +1; 
	   state <= LI6;
	   end
	 //Shift in U2U3 into registers, read V2V3
	 LI6: begin                                 	    
	   reg_U5 <= SRAM_read_data[7:0];        
	   reg_U4 <= SRAM_read_data[15:8];
	   reg_U3 <= reg_U5;
	   reg_U2 <= reg_U4;
	   
	   SRAM_address <= V_offset + vpixel;
	   vpixel <= vpixel +1;  
	   state <= LI7;
	   end
	 //Shift in  U4U5 into registers, read V4V5
	 LI7: begin
	   reg_U5 <= SRAM_read_data[7:0];        
	   reg_U4 <= SRAM_read_data[15:8];
	   reg_U3 <= reg_U5;
	   reg_U2 <= reg_U4;
	   reg_U1 <= reg_U3;
	   reg_U0 <= reg_U2;                       
	   
	   SRAM_address <= V_offset + vpixel;
	   vpixel <= vpixel +1;  
	   state <= LI8;
	   end      
	 //Shift in V0V1, begin calculating U'1                                  
	 LI8: begin                              
     reg_V5 <= SRAM_read_data[7:0];                   
	   reg_V4 <= SRAM_read_data[15:8];

	   op1 <= 32'd21;
	   op2 <= reg_U0 + reg_U3;
	   op3 <= -32'd52;
	   op4 <= reg_U0 + reg_U2;
	   op5 <= 32'd159;
	   op6 <= reg_U0 + reg_U1;
	   
	   state <= LI9;
    end
    //Shift in V2V3, finish calculating U'1
    LI9: begin                                          
     reg_V5 <= SRAM_read_data[7:0];
	   reg_V4 <= SRAM_read_data[15:8];
	   reg_V3 <= reg_V5;
	   reg_V2 <= reg_V4;
	   
	   U_p <= $signed(M1 + M2 + M3 + 32'd128)>>>8;
	   
	   state <= LI10;
	  end
	  //shift in V4V5,
	  LI10: begin
	   reg_V5 <= SRAM_read_data[7:0];
	   reg_V4 <= SRAM_read_data[15:8];
	   reg_V3 <= reg_V5;
	   reg_V2 <= reg_V4;
	   reg_V1 <= reg_V3;
	   reg_V0 <= reg_V2;                                
	   
	   state <= LI11;
   end
   //All V values are in registers so we can start calculating V'1
   LI11: begin
     op1 <= 32'd21;
     op2 <= reg_V0 + reg_V3;
     op3 <= -32'd52;
     op4 <= reg_V0 + reg_V2;
     op5 <= 32'd159;
     op6 <= reg_V0 + reg_V1;
	   
	   state <= LI12;
	   end
	   //finish calculating V'1, perform first 3 matrix multiplications
	   LI12: begin
	     V_p <= $signed(M1 + M2 + M3 + 32'd128)>>>8;
	     
	     op1 <= a00;
	     op2 <= reg_Y0 - 32'd16;
	     op3 <= a02;
	     op4 <= reg_V0 - 32'd128;
	     op5 <= a11;
	     op6 <= reg_U0 - 32'd128;
	      
	     state <= LI13;
	   end
	   //Calculate R0, and the partial products for G0B0, set up multipliers for final matrix multiplications
	   LI13: begin
	 
  	    if(R1[31] == 1'b1)begin
  	      R <= 0;
  	    end else
  	    if(|R1[30:24] == 1'b1) begin
  	      R <= 8'd255;
  	    end else begin
  	      R <= R1[23:16];
  	    end    
     	     
	     hold_G <= M1 + M3;    
	     hold_B <= M1;        
	     
	     op3 <= a12;
	     op4 <= reg_V0 - 32'd128;
	     op5 <= a21;
	     op6 <= reg_U0 - 32'd128;
	     
	     state <= LI14;
	   end
	   //Calculate G0B0
	   LI14: begin
    

  	    if(G1[31] == 1'b1)begin
  	      G <= 0;
  	    end else
  	    if(|G1[30:24] == 1'b1) begin
  	      G <= 8'd255;
  	    end else begin
  	      G <= G1[23:16];
  	    end    
  
  	    if(B1[31] == 1'b1)begin
  	      B <= 0;
  	    end else
  	    if(|B1[30:24] == 1'b1) begin
  	      B <= 8'd255;
  	    end else begin
  	      B <= B1[23:16];
  	    end    

	     
	     state <= LI15; 
	   end
	   //Write R0G0, and calculate R1G1B1 using U'1 and V'1, B is held in its register                                  
	   LI15: begin
	     SRAM_we_n <= 0;
	     SRAM_address <= RGB_offset + RGBpixel;  
	     RGBpixel <= RGBpixel + 1;
	     
	     SRAM_write_data <= {R,G};   
	     
	     op1 <= a00;                                               
	     op2 <= reg_Y1 - 32'd16;                             
	     op3 <= a02;
	     op4 <= V_p - 32'd128;
	     op5 <= a11;
	     op6 <= U_p - 32'd128;
	                                                             
	     state <= LI16;
	   end
	   //Complete R1, and calculate partial products of G1B1
	   LI16: begin
	     SRAM_we_n <= 1;


  	    if(R1[31] == 1'b1)begin
  	      R <= 0;
  	    end else
  	    if(|R1[30:24] == 1'b1) begin
  	      R <= 8'd255;
  	    end else begin
  	      R <= R1[23:16];
  	    end    	     
	     
	     hold_G <= M1 + M3;    
	     hold_B <= M1;         
	     
	     op3 <= a12;
	     op4 <= V_p - 32'd128;
	     op5 <= a21;
	     op6 <= U_p - 32'd128;
	     
	     state<= LI17;
	  	end  
	  	//Write B0R1 and Complete calculations for G1B1
	   LI17: begin
	     
	     SRAM_we_n <= 0;
	     
	     SRAM_address <= RGB_offset + RGBpixel;
	     RGBpixel <= RGBpixel + 1;
	     
	     SRAM_write_data <= {B,R};   //// write B0R1 
	 
  	    if(G1[31] == 1'b1)begin
  	      G <= 0;
  	    end else
  	    if(|G1[30:24] == 1'b1) begin
  	      G <= 8'd255;
  	    end else begin
  	      G <= G1[23:16];
  	    end    
  
  	    if(B1[31] == 1'b1)begin
  	      B <= 0;
  	    end else
  	    if(|B1[30:24] == 1'b1) begin
  	      B <= 8'd255;
  	    end else begin
  	      B <= B1[23:16];
  	    end    

	     state<= LI18;   
	   end
	   //Calculating first 3 matrix multiplications for RGB2
	   LI18: begin 
	     SRAM_we_n <= 1;
	     
	     op1 <= a00;
	     op2 <= reg_Y2 - 32'd16;
	     op3 <= a02;
	     op4 <= reg_V1 - 32'd128;
	     op5 <= a11;
	     op6 <= reg_U1 - 32'd128;
	   
	     state<= LI19;
	   end
	   //Write G1B1, complete R2, completing 
	   LI19: begin
	     SRAM_we_n <= 0;
	     SRAM_address <= RGB_offset + RGBpixel;
	     RGBpixel <= RGBpixel + 1;
	     
	     SRAM_write_data <= {G,B};  

  	    if(R1[31] == 1'b1)begin
  	      R <= 0;
  	    end else
  	    if(|R1[30:24] == 1'b1) begin
  	      R <= 8'd255;
  	    end else begin
  	      R <= R1[23:16];
  	    end    

  	            
	     hold_G <= M1 + M3;    //// incomplete G2 and B2 value
	     hold_B <= M1;
	     
	     
	     op3 <= a12;
	     op4 <= reg_V1 - 32'd128;
	     op5 <= a21;
	     op6 <= reg_U1 - 32'd128;
	                                                             
	     state<= LI20;
	   
	   end
	   LI20: begin
	     
	     SRAM_we_n <= 1;

  	    if(G1[31] == 1'b1)begin
  	      G <= 0;
  	    end else
  	    if(|G1[30:24] == 1'b1) begin
  	      G <= 8'd255;
  	    end else begin
  	      G <= G1[23:16];
  	    end    
  
  	    if(B1[31] == 1'b1)begin
  	      B <= 0;
  	    end else
  	    if(|B1[30:24] == 1'b1) begin
  	      B <= 8'd255;
  	    end else begin
  	      B <= B1[23:16];
  	    end    
    
	     op1 <= 21;
	     op2 <= reg_U0 + reg_U4;
	     op3 <= -52;
	     op4 <= reg_U0 + reg_U3;
	     op5 <= 159;
	     op6 <= reg_U1 + reg_U2;
	     
	     state <= LI21;
	     
	   end
	   LI21: begin
	     
	     SRAM_we_n <= 0;
	     SRAM_address <= RGB_offset + RGBpixel;
	     RGBpixel <= RGBpixel + 1;
	     
	     SRAM_write_data <= {R,G};    //// write R2G2
	     
	     U_p <= $signed(M1 + M2 + M3 + 32'd128)>>>8;   //// complete U'3
	     
	     
	     op1 <= 21;
	     op2 <= reg_V0 + reg_V4;
	     op3 <= -52;
	     op4 <= reg_V0 + reg_V3;
	     op5 <= 159;
	     op6 <= reg_V1 + reg_V2;
	     
	     
	     state <= LI22;
	   
	   end
	   LI22: begin
	     
	     SRAM_we_n <= 1;
	     
	     V_p <= $signed(M1 + M2 + M3 + 32'd128)>>>8;   //// complete V'3
	     state <= LI23;
	   end 
	   LI23: begin
	     op1 <= a00;
	     op2 <= reg_Y3 - 32'd16;
	     op3 <= a02;
	     op4 <= V_p - 32'd128;
	     op5 <= a11;
	     op6 <= U_p - 32'd128;
       
       state <= LI24;
       
	   end
	   LI24: begin

  	    if(R1[31] == 1'b1)begin
  	      R <= 0;
  	    end else
  	    if(|R1[30:24] == 1'b1) begin
  	      R <= 8'd255;
  	    end else begin
  	      R <= R1[23:16];
  	    end    

  
	     hold_G <= M1 + M3;    //// incomplete G3 and B3 value
	     hold_B <= M1;
	     
	     
	     op3 <= a12;
	     op4 <= V_p - 32'd128;
	     op5 <= a21;
	     op6 <= U_p - 32'd128;  
	     
	     state <= LI25;
	     
	   end
	   LI25: begin


  	    if(G1[31] == 1'b1)begin
  	      G <= 0;
  	    end else
  	    if(|G1[30:24] == 1'b1) begin
  	      G <= 8'd255;
  	    end else begin
  	      G <= G1[23:16];
  	    end    
  
  	    if(B1[31] == 1'b1)begin
  	      B <= 0;
  	    end else
  	    if(|B1[30:24] == 1'b1) begin
  	      B <= 8'd255;
  	    end else begin
  	      B <= B1[23:16];
  	    end    

	     SRAM_we_n <= 0;
	     SRAM_address <= RGB_offset + RGBpixel;
	     RGBpixel <= RGBpixel + 1;
	     
	     SRAM_write_data <= {B,R};   //// write B2R3
	     
	     state <= LI26;
	     
	   end
	   LI26: begin
	     UV_val <= UV_val + 5;
	     
	     SRAM_address <= RGB_offset + RGBpixel;
	     RGBpixel <= RGBpixel + 1;
	     SRAM_we_n <= 0;
	     SRAM_write_data <= {G,B};    //// write G3B3
	    
	     r_flag <= 1;
	     state <= CC1;
	     end
	  CC1: begin
	    SRAM_we_n <= 1;
	    
	    if(r_flag && UV_val < 8'd159)begin
	     SRAM_address <= U_offset + upixel;  // assign values in CC4  
	    end if(~r_flag && UV_val < 8'd159)begin
	     SRAM_address <= U_offset + upixel;  // assign values in CC4  
	     upixel <= upixel +1;
	    end
	    
	    op1 <= a00;                          // operands for RGB even
	    op2 <= reg_Y4 - 32'd16;
	    op3 <= a02;
	    op4 <= reg_V2 - 32'd128;
	    op5 <= a11;
	    op6 <= reg_U2 - 32'd128;

	    state <= CC2;
	  end
	  CC2: begin
	    
	    if(r_flag && UV_val < 8'd159)begin
	     SRAM_address <= V_offset + vpixel;    //assign values in CC5
	    end
	    
	    if(~r_flag && UV_val < 8'd159)begin
	     SRAM_address <= V_offset + vpixel;    
	     vpixel <= vpixel +1;
	    end 

	 
  	    if(R1[31] == 1'b1)begin
  	      R <= 0;
  	    end else
  	    if(|R1[30:24] == 1'b1) begin
  	      R <= 8'd255;
  	    end else begin
  	      R <= R1[23:16];
  	    end    
	    
	     hold_G <= (M1 + M3);    //// incomplete G & B even value
	     hold_B <= M1;
	     
	     op3 <= a12;
	     op4 <= reg_V2 - 32'd128;
	     op5 <= a21;
	     op6 <= reg_U2 - 32'd128;     
	                                                            
	     state <= CC3;
	  end
	  CC3: begin
	 
	    if(G1[31] == 1'b1)begin
	      G <= 0;
	    end else
	    if(|G1[30:24] == 1'b1) begin
	      G <= 8'd255;
	    end else begin
	      G <= G1[23:16];
	    end    

	    if(B1[31] == 1'b1)begin
	      B <= 0;
	    end else
	    if(|B1[30:24] == 1'b1) begin
	      B <= 8'd255;
	    end else begin
	      B <= B1[23:16];
	    end    

	     op1 <= 21;                            //// calculating U prime
	     op2 <= reg_U0 + reg_U5;                            
	     op3 <= -52;
	     op4 <= reg_U1 + reg_U4;                            
	     op5 <= 159;
	     op6 <= reg_U2 + reg_U3;                              
	    
	     state <= CC4;
	  end
	  CC4: begin
	    
	    if(r_flag && UV_val < 8'd159)begin
	     reg_U5 <= SRAM_read_data[15:8];          //read v4v5 from mem
	     reg_U4 <= reg_U5;
	     reg_U3 <= reg_U4;
	     reg_U2 <= reg_U3;
	     reg_U1 <= reg_U2;
	     reg_U0 <= reg_U1;
	    end
	    
	    if(~r_flag && UV_val < 8'd159)begin
	     reg_U5 <= SRAM_read_data[7:0];          //read v4v5 from mem
	     reg_U4 <= reg_U5;
	     reg_U3 <= reg_U4;
	     reg_U2 <= reg_U3;
	     reg_U1 <= reg_U2;
	     reg_U0 <= reg_U1;
	    end
	     
	     SRAM_address <= RGB_offset + RGBpixel;
	     RGBpixel <= RGBpixel + 1;
	     SRAM_we_n <= 0;
	     
	     SRAM_write_data <= {R,G};       //// writing R even G even
	     
	     U_p <= $signed(M1 + M2 + M3 + 32'd128)>>>8;   //// complete U prime
	     
	     op1 <= 21;                                //// calculating V prime
	     op2 <= reg_V0 + reg_V5;
	     op3 <= -52;
	     op4 <= reg_V1 + reg_V4;
	     op5 <= 159;
	     op6 <= reg_V2 + reg_V3;
	     	     
	     state <= CC5;
	  end
	  CC5: begin
	     
	    SRAM_we_n <= 1;
	   if(r_flag && UV_val < 8'd159)begin  
	    reg_V5 <= SRAM_read_data[15:8];
	    reg_V4 <= reg_V5;
	    reg_V3 <= reg_V4;
	    reg_V2 <= reg_V3;
	    reg_V1 <= reg_V2;
	    reg_V0 <= reg_V1;
	   end 
	   
	   if(~r_flag && UV_val < 8'd159)begin  
	    reg_V5 <= SRAM_read_data[7:0];
	    reg_V4 <= reg_V5;
	    reg_V3 <= reg_V4;
	    reg_V2 <= reg_V3;
	    reg_V1 <= reg_V2;
	    reg_V0 <= reg_V1;
	   end 
	    
	    UV_val <= UV_val +1;
	    
	    V_p <= $signed(M1 + M2 + M3 + 32'd128)>>>8;    //// complete V prime
	    
	    state <= CC6;
	  end  
	  CC6: begin
	    
	    SRAM_address <= ypixel;    
	    ypixel <= ypixel +1;
	   
	   
	    
	    op1 <= a00;
	    op2 <= reg_Y5 - 32'd16;
	    op3 <= a02;
	    op4 <= V_p - 32'd128;
	    op5 <= a11;
	    op6 <= U_p - 32'd128;                  
	    
	    state <= CC7;
	  end 
	  CC7: begin
	    
	 
	    if(R1[31] == 1'b1)begin
	      R <= 0;
	    end else
	    if(|R1[30:24] == 1'b1) begin
	      R <= 8'd255;
	    end else begin
	      R <= R1[23:16];
	    end    
	      
	    hold_G <= M1 + M3;    //// incomplete G odd and B ood value
	    hold_B <= M1;
	     
	    op3 <= a12;
	    op4 <= V_p - 32'd128;
	    op5 <= a21;
	    op6 <= U_p - 32'd128;
	    
	    state <= CC8;
	 end
	 CC8: begin
	   SRAM_address <= RGB_offset + RGBpixel;
	   RGBpixel <= RGBpixel + 1;
	   SRAM_we_n <= 0;
	     
	   SRAM_write_data <= {B,R};       ///// writing B even R odd 
	   
	    if(G1[31] == 1'b1)begin
	      G <= 0;
	    end else
	    if(|G1[30:24] == 1'b1) begin
	      G <= 8'd255;
	    end else begin
	      G <= G1[23:16];
	    end    

	    if(B1[31] == 1'b1)begin
	      B <= 0;
	    end else
	    if(|B1[30:24] == 1'b1) begin
	      B <= 8'd255;
	    end else begin
	      B <= B1[23:16];
	    end    
	   
	   
	   state <= CC9;    
	   end
	   CC9: begin
	    
	    r_flag <= ~r_flag;
	     
	    SRAM_address <= RGB_offset + RGBpixel;
	    RGBpixel <= RGBpixel + 1;
	    SRAM_we_n <= 0;
	     
	    SRAM_write_data <= {G,B};        //// writing GB odd
	    
	    reg_Y5 <= SRAM_read_data[7:0]; //read u4u5
	    reg_Y4 <= SRAM_read_data[15:8];
	    reg_Y3 <= reg_Y5;
	    reg_Y2 <= reg_Y4;
	    reg_Y1 <= reg_Y3;
	    reg_Y0 <= reg_Y2;
	     
	    if(UV_val < 9'd160)begin
	      state <= CC1;
	    end else state <= LO0;
	     
	    
	    
	    end
	    LO0: begin 
	    
	     UV_val <= 0;
	     op1 <= a00;                          // operands for RGB 314 even
	     op2 <= reg_Y4 - 32'd16;
	     op3 <= a02;
	     op4 <= reg_V3 - 32'd128;
	     op5 <= a11;
	     op6 <= reg_U3 - 32'd128; 
	     
	     SRAM_we_n <= 1;                     // read Y 316 Y317
	     SRAM_address <= ypixel;
	     ypixel <= ypixel + 1;
	    
	     state <= LO1; 
	     
	   end 
	   LO1: begin
	    
	    SRAM_we_n <= 1;                     // read Y 318 Y319
	    SRAM_address <= ypixel;
	    ypixel <= ypixel + 1;
	     
  	    if(R1[31] == 1'b1)begin
  	      R <= 0;
  	    end else
  	    if(|R1[30:24] == 1'b1) begin
  	      R <= 8'd255;
  	    end else begin
  	      R <= R1[23:16];
  	    end    
	    
	     hold_G <= (M1 + M3);    //// incomplete G & B even value
	     hold_B <= M1;
	     
	     op3 <= a12;
	     op4 <= reg_V3 - 32'd128;
	     op5 <= a21;
	     op6 <= reg_U3 - 32'd128;     
	                                                            
	     state <= LO2;   
	    end
	    LO2: begin

  	    if(G1[31] == 1'b1)begin
  	      G <= 0;
  	    end else
  	    if(|G1[30:24] == 1'b1) begin
  	      G <= 8'd255;
  	    end else begin
  	      G <= G1[23:16];
  	    end    
  
  	    if(B1[31] == 1'b1)begin
  	      B <= 0;
  	    end else
  	    if(|B1[30:24] == 1'b1) begin
  	      B <= 8'd255;
  	    end else begin
  	      B <= B1[23:16];
  	    end    
	    	    
	     op1 <= 21;                            //// calculating U prime
	     op2 <= reg_U1 + reg_U5;                            
	     op3 <= -52;
	     op4 <= reg_U2 + reg_U5;                            
	     op5 <= 159;
	     op6 <= reg_U3 + reg_U4;
	     
	     state <= LO3;
	    end
	    LO3: begin
	     
    	   reg_Y5 <= SRAM_read_data[7:0]; //read u4u5
    	   reg_Y4 <= SRAM_read_data[15:8];
    	   reg_Y3 <= reg_Y5;
    	   reg_Y2 <= reg_Y4;
    	   reg_Y1 <= reg_Y3;
    	   reg_Y0 <= reg_Y2;
	     
	     
	     SRAM_address <= RGB_offset + RGBpixel;
	     RGBpixel <= RGBpixel + 1;
	     SRAM_we_n <= 0;
	     
	     SRAM_write_data <= {R,G};       //// writing R even G even
	     
	     U_p <= $signed(M1 + M2 + M3 + 32'd128)>>>8;   //// complete U prime
	     
	     
	     op1 <= 21;                                //// calculating V prime
	     op2 <= reg_V1 + reg_V5;
	     op3 <= -52;
	     op4 <= reg_V2 + reg_V5;
	     op5 <= 159;
	     op6 <= reg_V3 + reg_V4;
	     
	     state <= LO4;
	     
	    end
	    LO4: begin
	      
	     SRAM_we_n <= 1; 
	     reg_Y5 <= SRAM_read_data[7:0]; // 319
	     reg_Y4 <= SRAM_read_data[15:8];// 318 
	     reg_Y3 <= reg_Y5;              // 317           
	     reg_Y2 <= reg_Y4;              // 316
	     reg_Y1 <= reg_Y3;              // 315
	     reg_Y0 <= reg_Y2;              // 314
	     
	     V_p <= $signed(M1 + M2 + M3 + 32'd128)>>>8;    //// complete V prime 
	     state <= LO5;
	     
	    end  
	    LO5: begin
	      
	      
	     op1 <= a00;
	     op2 <= reg_Y1 - 32'd16;
	     op3 <= a02;
	     op4 <= V_p - 32'd128;
	     op5 <= a11;
	     op6 <= U_p - 32'd128;                  
 
	     state <= LO6;
	    end
	    LO6: begin

  	    if(R1[31] == 1'b1)begin
  	      R <= 0;
  	    end else
  	    if(|R1[30:24] == 1'b1) begin
  	      R <= 8'd255;
  	    end else begin
  	      R <= R1[23:16];
  	    end    

	     hold_G <= M1 + M3;    //// incomplete G315 odd and B315 odd value
	     hold_B <= M1;
 
	     op3 <= a12;
	     op4 <= V_p - 32'd128;
	     op5 <= a21;
	     op6 <= U_p - 32'd128;
      
       state <= LO7;
       	       
	    end
	    LO7: begin
	      
	      SRAM_address <= RGB_offset + RGBpixel;
    	   RGBpixel <= RGBpixel + 1;
    	   SRAM_we_n <= 0;
    	     
    	   SRAM_write_data <= {B,R};       ///// writing B314 even R315 odd 

  	    if(G1[31] == 1'b1)begin
  	      G <= 0;
  	    end else
  	    if(|G1[30:24] == 1'b1) begin
  	      G <= 8'd255;
  	    end else begin
  	      G <= G1[23:16];
  	    end    
  
  	    if(B1[31] == 1'b1)begin
  	      B <= 0;
  	    end else
  	    if(|B1[30:24] == 1'b1) begin
  	      B <= 8'd255;
  	    end else begin
  	      B <= B1[23:16];
  	    end    
    	   
    	   state <= LO8;  
	      
	    end
	    LO8: begin
	      
	     SRAM_address <= RGB_offset + RGBpixel;
 	     RGBpixel <= RGBpixel + 1;
  	    SRAM_we_n <= 0;
    	     
  	    SRAM_write_data <= {G,B};       ///// writing G315 odd B315 odd 
            	    
  	    op1 <= a00;                          // operands for RGB even
  	    op2 <= reg_Y2 - 32'd16;
  	    op3 <= a02;
  	    op4 <= reg_V4 - 32'd128;
  	    op5 <= a11;
  	    op6 <= reg_U4 - 32'd128; 

	     state <= LO9;
	    end
	    LO9: begin
	      
	     SRAM_we_n <= 1; 
  	    if(R1[31] == 1'b1)begin
  	      R <= 0;
  	    end else
  	    if(|R1[30:24] == 1'b1) begin
  	      R <= 8'd255;
  	    end else begin
  	      R <= R1[23:16];
  	    end    

	     hold_G <= (M1 + M3);    //// incomplete G & B even value
	     hold_B <= M1;
	     
	     op3 <= a12;
	     op4 <= reg_V4 - 32'd128;
	     op5 <= a21;
	     op6 <= reg_U4 - 32'd128;     
       
       state <= LO10; 
	    
	    end   
	    LO10: begin

  	    if(G1[31] == 1'b1)begin
  	      G <= 0;
  	    end else
  	    if(|G1[30:24] == 1'b1) begin
  	      G <= 8'd255;
  	    end else begin
  	      G <= G1[23:16];
  	    end    
  
  	    if(B1[31] == 1'b1)begin
  	      B <= 0;
  	    end else
  	    if(|B1[30:24] == 1'b1) begin
  	      B <= 8'd255;
  	    end else begin
  	      B <= B1[23:16];
  	    end    
	    	    
	     op1 <= 21;                            //// calculating U prime
	     op2 <= reg_U2 + reg_U5;                            
	     op3 <= -52;
	     op4 <= reg_U3 + reg_U5;                            
	     op5 <= 159;
	     op6 <= reg_U4 + reg_U5;
	     
	     state <= LO11;	      
	    end
	    LO11: begin
	    	
	    	U_p <= $signed(M1 + M2 + M3 + 32'd128)>>>8;   //// complete U prime
	    	
	    	SRAM_address <= RGB_offset + RGBpixel;
 	     RGBpixel <= RGBpixel + 1;
  	    SRAM_we_n <= 0;
    	     
  	    SRAM_write_data <= {R,G};       ///// writing R316 even B316 even 
       
	     op1 <= 21;                            //// calculating U prime
	     op2 <= reg_V2 + reg_V5;                            
	     op3 <= -52;
	     op4 <= reg_V3 + reg_V5;                            
	     op5 <= 159;
	     op6 <= reg_V4 + reg_V5;
       
       state <= LO12;
	    end
	    LO12: begin
	     
	     SRAM_we_n <= 1;
	     V_p <= $signed(M1 + M2 + M3 + 32'd128)>>>8;   //// complete V prime
	     
	     state <= LO13;
	     
	    end
	    LO13: begin
	      
	     op1 <= a00;
	     op2 <= reg_Y3 - 32'd16;
	     op3 <= a02;
	     op4 <= V_p - 32'd128;
	     op5 <= a11;
	     op6 <= U_p - 32'd128;                  
	     state <= LO14;
	     
	    end 
	    LO14: begin

  	    if(R1[31] == 1'b1)begin
  	      R <= 0;
  	    end else
  	    if(|R1[30:24] == 1'b1) begin
  	      R <= 8'd255;
  	    end else begin
  	      R <= R1[23:16];
  	    end    
 
	     hold_G <= M1 + M3;    //// incomplete G317 odd and B317 odd value
	     hold_B <= M1;
 
	     op3 <= a12;
	     op4 <= V_p - 32'd128;
	     op5 <= a21;
	     op6 <= U_p - 32'd128;
      
       state <= LO15;
	      
	    end
	    LO15: begin
	    	
	    	SRAM_address <= RGB_offset + RGBpixel;
 	     RGBpixel <= RGBpixel + 1;
  	    SRAM_we_n <= 0;
    	     
  	    SRAM_write_data <= {B,R};       ///// writing B316 even R317 odd 


  	    if(G1[31] == 1'b1)begin
  	      G <= 0;
  	    end else
  	    if(|G1[30:24] == 1'b1) begin
  	      G <= 8'd255;
  	    end else begin
  	      G <= G1[23:16];
  	    end    
  
  	    if(B1[31] == 1'b1)begin
  	      B <= 0;
  	    end else
  	    if(|B1[30:24] == 1'b1) begin
  	      B <= 8'd255;
  	    end else begin
  	      B <= B1[23:16];
  	    end    
  
       state <= LO16;
	    end
	    LO16: begin

	    	SRAM_address <= RGB_offset + RGBpixel;
 	     RGBpixel <= RGBpixel + 1;
  	    SRAM_we_n <= 0;
    	     
  	    SRAM_write_data <= {G,B};       ///// writing G317 odd B317 odd 
	     
  	    op1 <= a00;                          // operands for RGB even
  	    op2 <= reg_Y4 - 32'd16;
  	    op3 <= a02;
  	    op4 <= reg_V5 - 32'd128;
  	    op5 <= a11;
  	    op6 <= reg_U5 - 32'd128; 

	     state <= LO17;
	    end
	    LO17: begin
	      
	     SRAM_we_n <= 1; 
  	
  	    if(R1[31] == 1'b1)begin
  	      R <= 0;
  	    end else
  	    if(|R1[30:24] == 1'b1) begin
  	      R <= 8'd255;
  	    end else begin
  	      R <= R1[23:16];
  	    end    
  	    
	     hold_G <= (M1 + M3);    //// incomplete G & B even value
	     hold_B <= M1;
	     
	     op3 <= a12;
	     op4 <= reg_V5 - 32'd128;
	     op5 <= a21;
	     op6 <= reg_U5 - 32'd128;     
       
       state <= LO18; 
	    
	    end   
	    LO18: begin

  	    if(G1[31] == 1'b1)begin
  	      G <= 0;
  	    end else
  	    if(|G1[30:24] == 1'b1) begin
  	      G <= 8'd255;
  	    end else begin
  	      G <= G1[23:16];
  	    end    
  
  	    if(B1[31] == 1'b1)begin
  	      B <= 0;
  	    end else
  	    if(|B1[30:24] == 1'b1) begin
  	      B <= 8'd255;
  	    end else begin
  	      B <= B1[23:16];
  	    end
  	    
  	       
	     op1 <= 21;                            //// calculating U prime
	     op2 <= reg_U3 + reg_U5;                            
	     op3 <= -52;
	     op4 <= reg_U4 + reg_U5;                            
	     op5 <= 159;
	     op6 <= reg_U5 + reg_U5;
	     
	     state <= LO19;	      
	    end
	    LO19: begin
	    	
	    	U_p <= $signed(M1 + M2 + M3 + 32'd128)>>>8;   //// complete U prime
	    	
	    	SRAM_address <= RGB_offset + RGBpixel;
 	     RGBpixel <= RGBpixel + 1;
  	    SRAM_we_n <= 0;
    	     
  	    SRAM_write_data <= {R,G};       ///// writing R316 even B316 even 
       
	     op1 <= 21;                            //// calculating V prime
	     op2 <= reg_V3 + reg_V5;                            
	     op3 <= -52;
	     op4 <= reg_V4 + reg_V5;                            
	     op5 <= 159;
	     op6 <= reg_V5 + reg_V5;
       
       state <= LO20;
	    end
	    LO20: begin
	     
	     SRAM_we_n <= 1;
	     V_p <= $signed(M1 + M2 + M3 + 32'd128)>>>8;   //// complete V prime
	     
	     state <= LO21;
	     
	    end
	    LO21: begin
	      
	     op1 <= a00;                               ////operands for 317
	     op2 <= reg_Y5 - 32'd16;
	     op3 <= a02;
	     op4 <= V_p - 32'd128;
	     op5 <= a11;
	     op6 <= U_p - 32'd128;                  
	     state <= LO22;
	     
	    end 
	    LO22: begin
  	    if(R1[31] == 1'b1)begin
  	      R <= 0;
  	    end else
  	    if(|R1[30:24] == 1'b1) begin
  	      R <= 8'd255;
  	    end else begin
  	      R <= R1[23:16];
  	    end    
   
	     hold_G <= M1 + M3;    //// incomplete G317 odd and B317 odd value
	     hold_B <= M1;
 
	     op3 <= a12;
	     op4 <= V_p - 32'd128;
	     op5 <= a21;
	     op6 <= U_p - 32'd128;
      
       state <= LO23;
	      
	    end
	    LO23: begin
	    	
	    	SRAM_address <= RGB_offset + RGBpixel;
 	     RGBpixel <= RGBpixel + 1;
  	    SRAM_we_n <= 0;
    	     
  	    SRAM_write_data <= {B,R};       ///// writing B316 even R317 odd 

  	    if(G1[31] == 1'b1)begin
  	      G <= 0;
  	    end else
  	    if(|G1[30:24] == 1'b1) begin
  	      G <= 8'd255;
  	    end else begin
  	      G <= G1[23:16];
  	    end    
  
  	    if(B1[31] == 1'b1)begin
  	      B <= 0;
  	    end else
  	    if(|B1[30:24] == 1'b1) begin
  	      B <= 8'd255;
  	    end else begin
  	      B <= B1[23:16];
  	    end    
      
       state <= LO24;
	    end
	    LO24: begin

	    	SRAM_address <= RGB_offset + RGBpixel;
 	     RGBpixel <= RGBpixel + 1;
  	    SRAM_we_n <= 0;
    	     
  	    SRAM_write_data <= {G,B};       ///// writing G317 odd B317 odd 
	     
	     row <= row + 1;
	     
	     if(row < 9'd239)begin
	       state <= delay;
	     end else state <= finish_M1;
	    end
	    finish_M1: begin
	    SRAM_we_n <= 1;      
	    Stop <= 1'b1;
	      
	   end       
	   endcase
	 end
  end
endmodule
