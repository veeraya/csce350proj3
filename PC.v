module ProgramCounter(CLK, MasterReset_L, startPC, imm32, nPC_Sel, zero, PC);
	input CLK, MasterReset_L, nPC_Sel, zero;
	input [31:0] startPC, imm32;
	output [31:0] PC;
	reg [31:0] PC;
	wire [31:0] selectedPC;
	wire [31:0] pc0, pc1;
	wire PCSel;
	reg initialized;

	initial begin
		initialized = 0;
	end

	and andGate(PCSel, zero, nPC_Sel);
	MUX32_2to1 pcMux(pc0, pc1, PCSel, selectedPC);
	AdderFour addFour(pc0, PC, 4);
	AdderImm addImm(pc1, PC, imm32);

	always @(negedge CLK) begin
		if (!initialized) begin
			PC = startPC ;
			initialized = 1;
		end else if (MasterReset_L) begin
			PC = selectedPC;
		end else begin
			PC = startPC;
		end
	$display($time," PC: startPC = %d pc0 = %d, pc1 = %d, PCSel = %d, PC = %d", startPC, pc0, pc1, PCSel, PC);
	end
endmodule