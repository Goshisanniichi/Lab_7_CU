module Lab_cu (clk, reset, status, Instr, RegRW, ALUsrc, ALUop, c_in, MRW, WB, PCsrc, imm_sel);

input clk, reset;
input [3:0] status;
input [31:0] Instr;

output reg RegRW;  			// goes to register
output reg ALUsrc;  			// Mux that decides what goes into the ALU
output reg [3:0] ALUop; 	// Tells ALU what function to perform
output reg c_in;  			// this is the carry in bit to go to the ALU
output reg MRW;				// goes to RAM
output reg WB; 				// controls the final output and next instruction
output reg PCsrc;				// controls mux that sends new PC from branch instruction 
output reg [1:0] imm_sel;	// controls imm output accordig to ?-type 

	always @(Instr or reset or status)
		if (reset==0)
			case (Instr[6:0])

				7'b0000000: begin  	// adding more clock cycles
				RegRW = 1'b1;  		// goes to register	
				MRW = 1'b1;  			// goes to RAM  // Make it always 1
				end
		
				7'b0110011: begin  	// R-type instruction
				RegRW = 1'b1;  		// goes to register
				ALUsrc = 1'b0; 		// Mux that decides what goes into the ALU
				ALUop = 4'b0000;		// Tells ALU what function to perform
				c_in = 1'b0;  			// this is the carry in bit to go to the ALU
				MRW = 1'b1;	  			// goes to RAM  // Make it always 1
				WB = 1'b1; 				// controls the final output and next instruction
				PCsrc = 1'b0;			// controls mux that sends new PC from branch instruction
				imm_sel = 2'b11;		// controls imm output accordig to ?-type 
				end
		
		
				7'b0010011: begin  	// I-type instruction
				RegRW = 1'b1;  		// goes to register
				ALUsrc = 1'b1; 		// Mux that decides what goes into the ALU
				ALUop = 4'b0000;		// Tells ALU what function to perform
				c_in = 1'b0;  			// this is the carry in bit to go to the ALU
				MRW = 1'b1;	  			// goes to RAM  // Make it always 1
				WB = 1'b1; 				// controls the final output and next instruction
				PCsrc = 1'b0;			// controls mux that sends new PC from branch instruction
				imm_sel = 2'b00;		// controls imm output accordig to ?-type 
				end
		
		
				7'b0000011: begin  	// I-type instruction
				RegRW = 1'b1;  		// goes to register
				ALUsrc = 1'b1; 		// Mux that decides what goes into the ALU
				ALUop = 4'b0000;		// Tells ALU what function to perform
				c_in = 1'b0;  			// this is the carry in bit to go to the ALU
				MRW = 1'b0;	  			// goes to RAM  // Make it always 1
				WB = 1'b0; 				// controls the final output and next instruction
				PCsrc = 1'b0;			// controls mux that sends new PC from branch instruction
				imm_sel = 2'b00;		// controls imm output accordig to ?-type 
				end
		
		
				7'b0100011: begin  	// S-type instruction
				RegRW = 1'b0;  		// goes to register
				ALUsrc = 1'b0; 		// Mux that decides what goes into the ALU
				ALUop = 4'b0000;		// Tells ALU what function to perform
				c_in = 1'b0;  			// this is the carry in bit to go to the ALU
				MRW = 1'b1;	  			// goes to RAM  // Make it always 1
				WB = 1'b0; 				// controls the final output and next instruction
				PCsrc = 1'b0;			// controls mux that sends new PC from branch instruction
				imm_sel = 2'b01;		// controls imm output accordig to ?-type 
				end
		
		
				7'b0110011: begin  	// B-type instruction
				PCsrc = 1'b0;			// controls mux that sends new PC from branch instruction
				RegRW = 1'b0;  		// goes to register
				ALUsrc = 1'b0; 		// Mux that decides what goes into the ALU
				ALUop = 4'b1000;		// Tells ALU what function to perform
				c_in = 1'b0;  			// this is the carry in bit to go to the ALU
				MRW = 1'b0;	  			// goes to RAM  // Make it always 1
				WB = 1'b1; 				// controls the final output and next instruction		
				imm_sel = 2'b10;		// controls imm output accordig to ?-type */
				end
						3'b000: begin		// Branch ==
						PCsrc = status[0]? 1'b1 :1'b0;//PCsrc = status_flag[0]? 1'b1 :1'b0;
						end
				
						3'b100: begin		// Branch >
						PCsrc = status[2]? 1'b1 :1'b0; //PCsrc = status_flag[0]? 1'b1 :1'b0;
						end
					
			endcase

		
		else if (reset==1) 		// resets the system back to start
			case (Instr[6:0])

				7'b0000000: begin
				RegRW = 1'b1;  		// goes to register
				ALUsrc = 1'b0; 		// Mux that decides what goes into the ALU
				MRW = 1'b1;	  			// goes to RAM  // Make it always 1
				PCsrc = 1'b0;
				end
			endcase 
	
endmodule 		
		