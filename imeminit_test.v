initial begin
   Mem[0] = {32'h200a0001};
//            addi   $10, $0, 1
   Mem[1] = {32'h200b0002};
//            addi   $11, $0, 2
   Mem[2] = {32'h014b6022};
//            sub    $12, $10, $11    # $12 = ffffffff
   Mem[3] = {32'h014c6823};
//            subu   $13, $10, $12    # $13 = 2
   Mem[4] = {32'h014c7020};
//            add    $14, $10, $12    # $14 = 0
   Mem[5] = {32'h014c7821};
//            addu   $15, $10, $12    # $15 = 0
   Mem[6] = {32'h2550ffff};
//            addiu  $16, $10, -1     # $16 = 0

   Mem[7] = {32'h014b6024};
//            and    $12, $10, $11    # $12 = 0
   Mem[8] = {32'h314c0011};
//            andi   $12, $10, 17     # $12 = 1
   Mem[9] = {32'h014b6025};
//            or     $12, $10, $11    # $12 = 3
   Mem[10] = {32'h354c0012};
//            ori    $12, $10, 18     # $12 = 19
   Mem[11] = {32'h014b6026};
//            xor    $12, $10, $11    # $12 = 3
   Mem[12] = {32'h394c0012};
//            xori   $12, $10, 18     # $12 = 19

   Mem[13] = {32'h000a6040};
//            sll    $12, $10, 1      # $12 = 2
   Mem[14] = {32'h200dffff};
//            addi   $13, $0, -1      # $13 = ffffffff=-1
   Mem[15] = {32'h000d6043};
//            sra    $12, $13, 1      # $12 = ffffffff=-1
   Mem[16] = {32'h000d6042};
//            srl    $12, $13, 1      # $12 = 7fffffff

   Mem[17] = {32'h014b602a};
//  Nojump:   slt    $12, $10, $11    # $12 = 1
   Mem[18] = {32'h014d602b};
//            sltu   $12, $10, $13    # $12 = 1
   Mem[19] = {32'h294cfff0};
//            slti   $12, $10, -16    # $12 = 0
   Mem[20] = {32'h2d4cfff0};
//            sltiu  $12, $10, -16    # $12 = 1

   Mem[21] = {6'd4,5'd10,5'd11,-16'd5};
//            beq    $10, $11, Nojump
   Mem[22] = {6'd4,5'd10,5'd10,16'd2};
//            beq    $10, $10, Jump
   Mem[23] = {6'd8,5'd0,5'd12,16'd1};
//            addi   $12, $0, 1       # never executed
   Mem[24] = {6'd8,5'd0,5'd12,16'd1};
//            addi   $12, $0, 1       # never executed

   Mem[25] = {6'd5,5'd10,5'd11,16'd2};
//  Jump:     bne    $10, $11, Lessthan
   Mem[26] = {6'd8,5'd0,5'd12,16'd1};
//            addi   $12, $0, 1       # never executed
   Mem[27] = {6'd8,5'd0,5'd12,16'd1};
//            addi   $12, $0, 1       # never executed

   Mem[28] = {6'd2,26'd31};
//  Lessthan: j      JumpT
   Mem[29] = {6'd8,5'd0,5'd12,16'd1};
//            addi   $12, $0, 1       # never executed
   Mem[30] = {6'd8,5'd0,5'd12,16'd1};
//            addi   $12, $0, 1       # never executed

end
