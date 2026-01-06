`define R_TYPE 7'b0110011
`define LW_OP 7'b0000011
`define I_TYPE 7'b0010011
`define JALR_OP 7'b1100111
`define S_TYPE 7'b0100011
`define B_TYPE 7'b1100011
`define J_TYPE 7'b1101111
`define U_TYPE 7'b0110111

module controller (
    input [6:0] op,
    input [2:0] funct3,
    input funct75,
    output reg RegWriteD,
    output reg [1:0] ResultSrcD,
    output reg MemWriteD,
    output reg [1:0] JumpD,
    output reg [1:0] BranchD,
    output reg [2:0] ALUControlD,
    output reg ALUSrcD,
    output reg [2:0] ImmSrcD,
    output reg LUID
);

    always @(op, funct3, funct75) begin
        case (op)
            `R_TYPE: begin
                RegWriteD = 1'b1;
                ResultSrcD = 2'b00;
                MemWriteD = 1'b0;
                JumpD = 2'b00;
                BranchD = 2'b00;
                ALUSrcD = 1'b0;
                ImmSrcD = 3'b000;
                LUID = 1'b0;
                case (funct3)
                    3'b000: begin
                        if (funct75 == 1'b0)
                            ALUControlD = 3'b000;
                        else
                            ALUControlD = 3'b001;
                    end
                    3'b111: ALUControlD = 3'b010;
                    3'b110: ALUControlD = 3'b011;
                    3'b010: ALUControlD = 3'b101;
                endcase
            end
            `LW_OP: begin
                RegWriteD = 1'b1;
                ResultSrcD = 2'b01;
                MemWriteD = 1'b0;
                JumpD = 2'b00;
                BranchD = 2'b00;
                ALUControlD = 3'b000;
                ALUSrcD = 1'b1;
                ImmSrcD = 3'b000;
                LUID = 1'b0;
            end
            `I_TYPE: begin
                RegWriteD = 1'b1;
                ResultSrcD = 2'b00;
                MemWriteD = 1'b0;
                JumpD = 2'b00;
                BranchD = 2'b00;
                ALUSrcD = 1'b1;
                ImmSrcD = 3'b000;
                LUID = 1'b0;
                case (funct3)
                    3'b000: ALUControlD = 3'b000;
                    3'b110: ALUControlD = 3'b011;
                    3'b010: ALUControlD = 3'b101;
                endcase
            end
            `JALR_OP: begin
                RegWriteD = 1'b1;
                ResultSrcD = 2'b10;
                MemWriteD = 1'b0;
                JumpD = 2'b10;
                BranchD = 2'b00;
                ALUControlD = 3'b000;
                ALUSrcD = 1'b1;
                ImmSrcD = 3'b000;
                LUID = 1'b0;
            end
            `S_TYPE: begin
                RegWriteD = 1'b0;
                ResultSrcD = 2'b00;
                MemWriteD = 1'b1;
                JumpD = 2'b00;
                BranchD = 2'b00;
                ALUControlD = 3'b000;
                ALUSrcD = 1'b1;
                ImmSrcD = 3'b001;
                LUID = 1'b0;
            end
            `B_TYPE: begin
                RegWriteD = 1'b0;
                ResultSrcD = 2'b00;
                MemWriteD = 1'b0;
                JumpD = 2'b00;
                ALUControlD = 3'b001;
                ALUSrcD = 1'b0;
                ImmSrcD = 3'b010;
                LUID = 1'b0;
                case (funct3)
                    3'b000: BranchD = 2'b01;
                    3'b001: BranchD = 2'b10;
                endcase
            end
            `J_TYPE: begin
                RegWriteD = 1'b1;
                ResultSrcD = 2'b10;
                MemWriteD = 1'b0;
                JumpD = 2'b01;
                BranchD = 2'b00;
                ALUControlD = 3'b000;
                ALUSrcD = 1'b0;
                ImmSrcD = 3'b011;
                LUID = 1'b0;
            end
            `U_TYPE: begin
                RegWriteD = 1'b1;
                ResultSrcD = 2'b11;
                MemWriteD = 1'b0;
                JumpD = 2'b00;
                BranchD = 2'b00;
                ALUControlD = 3'b000;
                ALUSrcD = 1'b0;
                ImmSrcD = 3'b100;
                LUID = 1'b1;
            end
            default: begin
                RegWriteD = 1'b1;
                ResultSrcD = 2'b00;
                MemWriteD = 1'b0;
                JumpD = 2'b00;
                BranchD = 2'b00;
                ALUControlD = 3'b000;
                ALUSrcD = 1'b0;
                ImmSrcD = 3'b000;
                LUID = 1'b0;
            end
        endcase
    end

endmodule