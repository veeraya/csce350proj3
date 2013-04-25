module SimpleAdder(sum, in1, in2);
	output [31:0] sum;
	reg [31:0] sum;
	input [31:0] in1, in2;

	always @(sum or in1 or in2) begin 
		sum = in1 + in2;
		$display($time,"sum = %d in1 = %d in2 = %d", sum, in1, in2);
	end
endmodule

module AdderFour(sum, in1, in2);
	output [31:0] sum;
	reg [31:0] sum;
	input [31:0] in1, in2;

	always @(sum or in1 or in2) begin 
		sum = in1 + in2;
		$display($time,"Plus4: sum = %d in1 = %d in2 = %d", sum, in1, in2);
	end
endmodule

module AdderImm(sum, in1, in2);
	output [31:0] sum;
	reg [31:0] sum;
	input [31:0] in1, in2;

	always @(sum or in1 or in2) begin 
		sum = in1 + in2;
		$display($time,"PlusImm: sum = %d in1 = %d in2 = %d", sum, in1, in2);
	end
endmodule
