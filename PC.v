module ProgramCounter(CLK, MasterReset_L, startPC, PC);
	input CLK, MasterReset_L;
	input [31:0] startPC;
	output [31:0] PC;
	reg [31:0] PC;
	reg initialized;

	initial begin
		initialized = 0;
	end

	always @(negedge CLK) begin
		if (!initialized) begin
			#2 PC = startPC - 4;
			initialized = 1;
		end else if (MasterReset_L) begin
			#2 PC = PC + 4;
		end else begin
			#2 PC = startPC - 4;
		end
	end
endmodule