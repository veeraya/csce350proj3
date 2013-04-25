// Texas A&M University          //
// cpsc350 Computer Architecture //
// $Id: SingleCycleProc.v,v 1.1 2002/04/08 23:16:14 miket Exp miket $ //
// Top Level Architecture Model //
`include "constants.v"
`include "IdealMemory.v"
`include "ALU_behav.v"
`include "Register.v"
`include "control.v"
`include "mux.v"
`include "signextend.v"
`include "MasterReset.v"
`include "PC.v"
/*-------------------------- CPU -------------------------------
 * This module implements a single-cycle
 * CPU similar to that described in the text book
 * (for example, see Figure 5.19).
 *
 */

//
// Input Ports
// -----------
// clock - the system clock (m555 timer).
//
// reset - when asserted by the test module, forces the processor to
//         perform a "reset" operation.  (note: to reset the processor
//         the reset input must be held asserted across a
//         negative clock edge).
//
//         During a reset, the processor loads an externally supplied
//         value into the program counter (see startPC below).
//
// startPC - during a reset, becomes the new contents of the program counter
//      (starting address of test program).
//
// Output Port
// -----------
// dmemOut - contains the data word read out from data memory. This is used
//           by the test module to verify the correctness of program
//           execution.
//-------------------------------------------------------------------------

module SingleCycleProc(CLK, Reset_L, startPC, dmemOut);
   input    Reset_L, CLK;
   input [31:0] startPC;
   output [31:0] dmemOut;
   wire [31:0] PC, instruction, ALUOut, busA, busB, B, imm32;
   wire ALUSrcB, RegDst, RegWrite, ALUOverflow, zero, carryOut, masterReset;
   wire [3:0] ALUOp;
   wire [4:0] Rw, Ra, Rb;
   wire [15:0] imm16;

   assign Ra = instruction[25:21]; //Rs
   assign Rb = instruction[20:16]; //Rt
   assign dmemOut = ALUOut;
   assign imm16 = instruction[15:0];

   MasterReset rst(CLK, Reset_L,masterReset);
   ProgramCounter pcMod(CLK, masterReset, startPC, PC);
   InstrMem instrMemBlk(PC, instruction);
   MainControl controlUnit(instruction[31:26], instruction[5:0], ALUSrcB, RegDst, RegWrite);
   MUX5_2to1 regDstMux(instruction[20:16], instruction[15:11],RegDst, Rw);
   ALUControl aluControlUnit(instruction[31:26], instruction[5:0], ALUOp);
   Register register(CLK, masterReset, Ra, Rb, Rw, ALUOut, RegWrite, busA, busB);
   SIGN_EXTEND extender(imm16, imm32);
   MUX32_2to1 BSelect(busB, imm32, ALUSrcB, B);
   ALU_behav alu(busA, B, ALUOp, ALUOut, ALUOverflow, 1'b0, carryOut, zero);

//
// Debugging threads that you may find helpful (you may have
// to change the variable names).
//
    // Monitor changes in the program counter
   always @(PC) begin
    $display($time," PC=%d  Instr: op=%d  rs=%d  rt=%d  rd=%d  imm16=%d  funct=%d\n",
   PC, instruction[31:26], instruction[25:21], instruction[20:16], instruction[15:11], instruction[15:0], instruction[5:0]);
     //$display($time, "WIRES: busA=%d busB=%d B=%d ALUSrcB=%d imm16=%d imm32=%d ", busA, busB, B, ALUSrcB, imm16, imm32);
     // $display($time," Control Unit: ALUSrcB=%d  RegDst=%d  RegWrite=%d  ", ALUSrcB, RegDst, RegWrite);
     // $display($time, " ALU Control Unit: opcode=%d  funct=%d  ALUOp=%d  ", instruction[31:26], instruction[5:0], ALUOp);
     // $display($time, "Register: Rw=%d writeData=%d RegWrite=%d busA=%d busB=%d", Rw, ALUOut, RegWrite, busA, busB);
  end

   /*   Monitors memory writes
   always @(MemWrite)
   begin
   #1 $display($time," MemWrite=%b clock=%d addr=%d data=%d",
               MemWrite, clock, dmemaddr, rportb);
   end
   */

endmodule // CPU


module m555 (CLK);
   parameter StartTime = 0, Ton = 50, Toff = 50, Tcc = Ton+Toff; //

   output CLK;
   reg     CLK;

   initial begin
      #StartTime CLK = 0;
   end

   // The following is correct if clock starts at LOW level at StartTime //
   always begin
      #Toff CLK = ~CLK;
      #Ton CLK = ~CLK;
   end
endmodule


module testCPU(Reset_L, startPC, testData);
   input [31:0] testData;
   output   Reset_L;
   output [31:0] startPC;
   reg       Reset_L;
   reg [31:0]   startPC;

   initial begin
      // Your program 1
      Reset_L = 0;  startPC = 0 * 4;
      #101 // insures reset is asserted across negative clock edge
     Reset_L = 1;
      #1300; // allow enough time for program 1 to run to completion
      Reset_L = 0;
      #1010 // reset
      Reset_L = 1;
      #1800;
      // Your program 2
      //startPC = 14 * 4;
      //#101 Reset_L = 1;
      //#10000;
      //Reset_L = 0;

      //#1 $display ("Program 2: Result: %d", testData);

      // etc.
      // Run other programs here


      $finish;
   end
endmodule // testCPU

module TopProcessor;
   wire reset, CLK, Reset_L;
   wire [31:0] startPC;
   wire [31:0] testData;

   m555 system_clock(CLK);
   SingleCycleProc SSProc(CLK, Reset_L, startPC, testData);
   testCPU tcpu(Reset_L, startPC, testData);

endmodule // TopProcessor