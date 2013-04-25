// ------------------------------------------------------------------------ //
// Texas A&M University                                                     //
// CPSC350 Computer Architecture                                            //
//                                                                          //
// $Id: ALU_behav.v,v 1.3 2002/11/14 16:06:04 miket Exp miket $             //
//                                                                          //
// ------------------------------------------------------------------------ //

// ------------------------------------------------------------------------ //
// Behavioral Verilog Module for a MIPS-like ALU                            //
// -- In continuous and procedure assignments Verilog extends the smaller   //
// operands by replicating their MSB, if it is equal to x, z; otherwise     //
// operends them with 0's. Arithmetic is interpreted as 2's C               //
// -- regs are considered as unsigned bit-vectors but the all arithmetic    //
// is done in 2's complement.                                               //
// At ALU instatiation time parameter n determines the ALU bit-size         //
// ------------------------------------------------------------------------ //



module ALU_behav( ADin, BDin, ALU_ctr, Result, Overflow, Carry_in, Carry_out, Zero );

   parameter n = 32, Ctr_size = 4;

   input     Carry_in;
   input [Ctr_size-1:0] ALU_ctr;
   input [n-1:0] 	ADin, BDin;
   output [n-1:0] 	Result;
   reg [n-1:0] 		Result, tmp;
   output 		Carry_out, Overflow, Zero;
   reg 			Carry_out, Overflow, Zero;

   always @(ALU_ctr or ADin or BDin or Carry_in)
     begin
         $display("ALU_ctr = %d", ALU_ctr);
	 case(ALU_ctr)
	   `ADD:  begin
	      {Carry_out, Result} = ADin + BDin + Carry_in;
	      Overflow = ADin[n-1] & BDin[n-1] & ~Result[n-1]
			 | ~ADin[n-1] & ~BDin[n-1] & Result[n-1];
	   end
	   `ADDU: {Overflow, Result} = ADin + BDin + Carry_in;
	   `SUB:  begin
	      {Carry_out, Result} = ADin - BDin;
	      Overflow = ADin[n-1] & ~BDin[n-1] & Result[n-1]
			 | ~ADin[n-1] & BDin[n-1] & ~Result[n-1];
          $display("SUB:- [%d] tmp = %d [%b]; Result = %d Cout=%b, Ovf=%b; A=%d, B=%d",
             $time, tmp, tmp, Result, Carry_out, Overflow, ADin, BDin );
	   end
	   `SUBU: {Overflow, Result} = ADin - BDin;
	   `SLT:  begin
	      {Carry_out, tmp} = ADin - BDin;
	      Overflow = ADin[n-1] & ~BDin[n-1] & ~tmp[n-1]
			 | ~ADin[n-1] & BDin[n-1] & tmp[n-1];
	      $display("SLT:- [%d] tmp = %d [%b]; Cout=%b, Ovf=%b; A=%d, B=%d",
		       $time, tmp, tmp, Carry_out, Overflow, ADin, BDin );

	      Result = tmp[n-1] ^ Overflow;
	      $display("SLT:+R=%d [%b]", Result, Result );

	   end
	   `SLTU: begin
	      {Carry_out, tmp} = ADin - BDin;
	      $display("SLTU:- [%d] tmp = %d [%b]; Cout=%b, Ovf=%b; A=%d, B=%d",
		       $time, tmp, tmp, Carry_out, Overflow, ADin, BDin );
	      Result = Carry_out;
	      $display("SLTU:+R=%d [%b]", Result, Result );
	   end
      `SLL:  begin
         Result = ADin << BDin[10:6];
         $display("SLL:Result = %d ADin = %d BDin[10:6] = %d", Result, ADin, BDin[10:6]);
      end
      `SRA:  begin
         Result = ADin >>> BDin[10:6];
         $display("SRA:Result = %d ADin = %d BDin[10:6] = %d", Result, ADin, BDin[10:6]);
      end
      `SRL:  begin
         Result = ADin >> BDin[10:6];
         $display("SRL:Result = %d ADin = %d BDin[10:6] = %d", Result, ADin, BDin[10:6]);
      end
	   `OR :  Result = ADin | BDin;
	   `AND:  Result = ADin & BDin;
	   `XOR:  Result = ADin ^ BDin;
	   `NOP:  Result = ADin;
	 endcase

	 Zero = ~| Result;  // Result = 32'b0
    if (ALU_ctr == `SUB) begin
       $display("Result = %d zero = %d", Result, Zero);
    end
      end
endmodule

// this is a test bench to test the ALU in isolation (without fetching instructions from instruction memory)
// uncomment it only when you are testing

// module TestALU;

   // parameter n = 32, Ctr_size = 4;

   // reg [n-1:0] A, B, T;
   // wire [n-1:0]  R, tt;
   // reg 	       Carry_in;
   // wire        Carry_out, Overflow, Zero;

   // reg [Ctr_size-1:0] ALU_ctr;

   // integer 	      num;

   // ALU_behav ALU( A, B, ALU_ctr, R, Overflow, Carry_in, Carry_out, Zero );

   // always @( R or Carry_out or Overflow or Zero )
      // begin
	 // $display("%0d\tA = %0d B = %0d; R = %0d; Cout = %b Ovfl = %b Zero = %b OP = %b n = %d",  $time, A, B, R, Carry_out, Overflow, Zero, ALU_ctr, num );
	 // num = num + 1;
      // end

   // initial begin
      // #0 num = 0; Carry_in = 0;
      // #1 A = 101; B = 0; ALU_ctr = `NOP;
      // #10 A = 10; B = 10; ALU_ctr = `ADD;
      // #10 A = 10; B = 20; ALU_ctr = `ADDU;
      // #10 A = 10; B = 20; ALU_ctr = `SLT;
      // #10 A = 10; B = 20; ALU_ctr = `SLTU;
      // #10 A = 32'hffffffff; B = 1; ALU_ctr = `ADDU;
      // #10 A = 10; B = 10; ALU_ctr = `ADDU;
      // #10 A = 10; B = 10; ALU_ctr = `SUB;
      // #10 A = 1; B = 1; ALU_ctr = `SUBU;
      // #10 A = 10; B = 10; ALU_ctr = `SUB;
      // #10 A = 10; B = 10; ALU_ctr = `SUBU;
      // #10 A = -13; B = -12; ALU_ctr = `SLT;
      // #100 $finish;
   // end
// endmodule
