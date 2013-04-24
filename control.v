`define OPCODE_R_type  6'b000000
// `include "SingleCycleProc.v"
// `include "ALU_behav.v"
module MainControl (opCode, ALUSrcBWire, RegDstWire, RegWriteWire);
    input [5:0] opCode;
    output ALUSrcBWire, RegDstWire, RegWriteWire;
    reg ALUSrcB, RegWrite, RegDst;

    always @(opCode) begin
        case (opCode)
            // add, sub, addu, subu
            `OPCODE_R_type :
                            begin
                                ALUSrcB = 0;
                                RegWrite = 1;
                                RegDst = 1;
                             end
            // addi
            `OPCODE_ADDI : begin
                            ALUSrcB = 1;
                            RegWrite = 1;
                            RegDst = 0;
                          end
            // addiu
            `OPCODE_ADDIU : begin
                             ALUSrcB = 1;
                             RegWrite = 1;
                             RegDst = 0;
                           end
            default: begin
                        ALUSrcB = 0;
                        RegWrite = 0;
                        RegDst = 0;
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

                        default : ALUOpReg = `NOP;
                    endcase
                end
            `OPCODE_ADDI : ALUOpReg = `ADD;
            `OPCODE_ADDIU : ALUOpReg = `ADDU;
            `OPCODE_ANDI : ALUOpReg = `AND;
            `OPCODE_ORI : ALUOpReg = `OR;
            `OPCODE_XORI : ALUOpReg = `XOR;

            default : ALUOpReg = `NOP;
        endcase
    end

    assign ALUOp = ALUOpReg;

endmodule

