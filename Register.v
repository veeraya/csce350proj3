module Register (CLK, MasterReset_L, readReg1, readReg2, writeReg, writeData, RegWrite, readData1, readData2);
   input [4:0] readReg1, readReg2, writeReg;
   input [31:0] writeData;
   input CLK, RegWrite, MasterReset_L;
   output [31:0] readData1, readData2;
   reg [31:0] register[31:0];
   reg[31:0] resetFlag, resetCount;
   reg prevReset_L;
   reg[7:0] i;

   initial begin
      register[0] = 32'b0;
   end
   always @(negedge CLK) begin
      if (MasterReset_L) begin
         if (RegWrite) begin
            #1 register[writeReg] = writeData;
            $display($time," Register: reg[%d]=%d reg[%d]=%d register[%d]=%d", readReg1, register[readReg1], readReg2,register[readReg2], writeReg, writeData);
         end
      end else begin
         $display("\t=========================Register Before Reset======================");
         for (i=0; i < 32; i = i + 1) begin
            $display($time, " Register[%d] = %d", i, register[i]);
         end 
         $display("\t=========================End of Register======================");
         // reset
         for (i=0; i < 32; i = i + 1) begin
            #1 register[i] = 0;
         end 
         $display("\n\n\t=========================Register After Reset======================"); 
         for (i=0; i < 32; i = i + 1) begin
            $display($time, " Register[%d] = %d", i, register[i]);
         end  
         $display("\t=========================End of Register======================\n\n");
      end
   end

   assign readData1 = register[readReg1];
   assign readData2 = register[readReg2];

endmodule // Imem

/*
module test_register();
   reg[4:0] readReg1, readReg2, writeReg;
   reg[31:0] writeData;
   reg RegWrite;
   wire CLK;
   wire [31:0] readData1, readData2;

   m555 c(CLK);

   Register register(CLK, readReg1, readReg2, writeReg, writeData, RegWrite, readData1, readData2);

   initial begin
      $monitor($time, "\treadReg1=%d\treadReg2=%d\twriteReg=%d\twriteData=%d\tRegWrite=%d\treadData1=%d\treadData2=%d", readReg1, readReg2, writeReg, writeData, RegWrite, readData1, readData2);
      writeReg = 0; writeData = 0; RegWrite = 1; #100
      writeReg = 1; writeData = 1; RegWrite = 1; #100
      writeReg = 2; writeData = 2; RegWrite = 1; #100
      writeReg = 3; writeData = 3; RegWrite = 1; #100
      writeReg = 4; writeData = 4; RegWrite = 1; #100
      writeReg = 5; writeData = 5; RegWrite = 1; #100
      writeReg = 6; writeData = 6; RegWrite = 1; #100
      writeReg = 7; writeData = 7; RegWrite = 1; #100
      writeReg = 8; writeData = 8; RegWrite = 1; #100
      writeReg = 9; writeData = 9; RegWrite = 1; #100
      writeReg = 10; writeData = 10; RegWrite = 1; #100
      writeReg = 11; writeData = 11; RegWrite = 1; #100
      writeReg = 12; writeData = 12; RegWrite = 1; #100
      writeReg = 13; writeData = 13; RegWrite = 1; #100
      writeReg = 14; writeData = 14; RegWrite = 1; #100
      writeReg = 15; writeData = 15; RegWrite = 1; #100
      writeReg = 16; writeData = 16; RegWrite = 1; #100
      writeReg = 17; writeData = 17; RegWrite = 1; #100
      writeReg = 18; writeData = 18; RegWrite = 1; #100
      writeReg = 19; writeData = 19; RegWrite = 1; #100
      writeReg = 20; writeData = 20; RegWrite = 1; #100
      RegWrite = 0; readReg1 = 0; readReg2 = 1; #100
      RegWrite = 0; readReg1 = 2; readReg2 = 3; #100
      RegWrite = 0; readReg1 = 4; readReg2 = 5; #100
      RegWrite = 0; readReg1 = 6; readReg2 = 7; #100
      RegWrite = 0; readReg1 = 8; readReg2 = 9; #100
      RegWrite = 0; readReg1 = 10; readReg2 = 11; #100
      RegWrite = 0; readReg1 = 12; readReg2 = 13; #100
      RegWrite = 0; readReg1 = 14; readReg2 = 15; #100
      RegWrite = 0; readReg1 = 16; readReg2 = 17; #100
      $finish;
   end

endmodule

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
*/