`define OPCODE_R_type  6'b000000
// `include "SingleCycleProc.v"
// `include "ALU_behav.v"
module MainControl (opCode, funct, ALUSrcBWire, RegDstWire, RegWriteWire, nPC_Sel);
    input [5:0] opCode, funct;
    output ALUSrcBWire, RegDstWire, RegWriteWire, nPC_Sel;
    reg ALUSrcB, RegWrite, RegDst, nPC_Sel ;

    always @(opCode) begin
        case (opCode)
            // add, sub, addu, subu, and, or, xor
            `OPCODE_R_type :
                            begin //if it's shift, Alu source B must be bit shift amt (bit [10:6])
                                if (funct == `FUNCT_SLL || funct == `FUNCT_SRA || funct == `FUNCT_SRL) begin
                                    ALUSrcB = 1;
                                    RegWrite = 1;
                                    RegDst = 1;
                                    nPC_Sel = 0;
                                end else begin
                                    ALUSrcB = 0;
                                    RegWrite = 1;
                                    RegDst = 1;
                                    nPC_Sel = 0;
                                end
                             end
            // addi
            `OPCODE_ADDI : begin
                            ALUSrcB = 1;
                            RegWrite = 1;
                            RegDst = 0;
                            nPC_Sel = 0;
                          end
            // addiu
            `OPCODE_ADDIU : begin
                             ALUSrcB = 1;
                             RegWrite = 1;
                             RegDst = 0;
                             nPC_Sel = 0;
                           end
            // ANDI
            `OPCODE_ANDI : begin
                             ALUSrcB = 1;
                             RegWrite = 1;
                             RegDst = 0;
                             nPC_Sel = 0;
                           end
            // ORI
            `OPCODE_ORI : begin
                             ALUSrcB = 1;
                             RegWrite = 1;
                             RegDst = 0;
                             nPC_Sel = 0;
                           end
            // XORI
            `OPCODE_XORI : begin
                             ALUSrcB = 1;
                             RegWrite = 1;
                             RegDst = 0;
                             nPC_Sel = 0;
                           end
            `OPCODE_SLTI : begin
                             ALUSrcB = 1;
                             RegWrite = 1;
                             RegDst = 0;
                             nPC_Sel = 0;
                           end
            `OPCODE_SLTIU : begin
                             ALUSrcB = 1;
                             RegWrite = 1;
                             RegDst = 0;
                             nPC_Sel = 0;
                            end
            `OPCODE_BEQ : begin
                             ALUSrcB = 0;
                             RegWrite = 1;
                             RegDst = 0;
                             nPC_Sel = 1;
                           end
            default: begin
                        ALUSrcB = 0;
                        RegWrite = 0;
                        RegDst = 0;
                        nPC_Sel = 0;
                     end
        endcase
    end

    assign ALUSrcBWire = ALUSrcB;
    assign RegWriteWire = RegWrite;
    assign RegDstWire = RegDst;
endmodule


module ALUControl(opCode, funct, ALUOp);
    input [5:0] opCode, funct;
    output [3:0] ALUOp;
    reg [3:0] ALUOpReg;

    always @(opCode or funct or ALUOp) begin
        case (opCode)
            `OPCODE_R_type :
                begin
                    case (funct)
                        `FUNCT_ADD :  ALUOpReg = `ADD;
                        `FUNCT_ADDU : ALUOpReg = `ADDU;
                        `FUNCT_SUB : ALUOpReg = `SUB;
                        `FUNCT_SUBU : ALUOpReg = `SUBU;
                        `FUNCT_AND : ALUOpReg = `AND;
                        `FUNCT_OR : ALUOpReg = `OR;
                        `FUNCT_XOR : ALUOpReg = `XOR;
                        `FUNCT_SLL : ALUOpReg = `SLL;
                        `FUNCT_SRA : ALUOpReg = `SRA;
                        `FUNCT_SRL : ALUOpReg = `SRL;
                        `FUNCT_SLT : ALUOpReg = `SLT;
                        `FUNCT_SLTU : ALUOpReg = `SLTU;

                        default : ALUOpReg = `NOP;
                    endcase
                end
            `OPCODE_ADDI : ALUOpReg = `ADD;
            `OPCODE_ADDIU : ALUOpReg = `ADDU;
            `OPCODE_ANDI : ALUOpReg = `AND;
            `OPCODE_ORI : ALUOpReg = `OR;
            `OPCODE_XORI : ALUOpReg = `XOR;
            `OPCODE_SLTI : ALUOpReg = `SLT;
            `OPCODE_SLTIU : ALUOpReg = `SLTU;
            `OPCODE_BEQ : ALUOpReg = `SUB;

            default : ALUOpReg = `NOP;
        endcase
    end

    assign ALUOp = ALUOpReg;

endmodule

