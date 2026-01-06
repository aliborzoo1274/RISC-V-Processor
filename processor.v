module processor (
    input clk,
    input rst
);

    wire RegWriteD;
    wire [1:0] ResultSrcD;
    wire MemWriteD;
    wire [1:0] JumpD;
    wire [1:0] BranchD;
    wire [2:0] ALUControlD;
    wire ALUSrcD;
    wire [2:0] ImmSrcD;
    wire LUID;
    wire StallF;
    wire StallD;
    wire FlushD;
    wire FlushE;
    wire [1:0] ForwardAE;
    wire [1:0] ForwardBE;
    wire [6:0] op;
    wire [2:0] funct3;
    wire funct75;
    wire [4:0] Rs1D;
    wire [4:0] Rs2D;
    wire [4:0] Rs1E;
    wire [4:0] Rs2E;
    wire [4:0] RdE;
    wire [1:0] PCSrcE;
    wire ResultSrcE0;
    wire [4:0] RdM;
    wire RegWriteM;
    wire [4:0] RdW;
    wire RegWriteW;

    datapath dp (
        .clk(clk),
        .rst(rst),
        .RegWriteD(RegWriteD),
        .ResultSrcD(ResultSrcD),
        .MemWriteD(MemWriteD),
        .JumpD(JumpD),
        .BranchD(BranchD),
        .ALUControlD(ALUControlD),
        .ALUSrcD(ALUSrcD),
        .ImmSrcD(ImmSrcD),
        .LUID(LUID),
        .StallF(StallF),
        .StallD(StallD),
        .FlushD(FlushD),
        .FlushE(FlushE),
        .ForwardAE(ForwardAE),
        .ForwardBE(ForwardBE),
        .op(op),
        .funct3(funct3),
        .funct75(funct75),
        .Rs1D(Rs1D),
        .Rs2D(Rs2D),
        .Rs1E(Rs1E),
        .Rs2E(Rs2E),
        .RdE(RdE),
        .PCSrcE(PCSrcE),
        .ResultSrcE0(ResultSrcE0),
        .RdM(RdM),
        .RegWriteM(RegWriteM),
        .RdW(RdW),
        .RegWriteW(RegWriteW)
    );

    controller ctrl (
        .op(op),
        .funct3(funct3),
        .funct75(funct75),
        .RegWriteD(RegWriteD),
        .ResultSrcD(ResultSrcD),
        .MemWriteD(MemWriteD),
        .JumpD(JumpD),
        .BranchD(BranchD),
        .ALUControlD(ALUControlD),
        .ALUSrcD(ALUSrcD),
        .ImmSrcD(ImmSrcD),
        .LUID(LUID)
    );

    hazard_unit hz (
        .Rs1D(Rs1D),
        .Rs2D(Rs2D),
        .RdE(RdE),
        .Rs1E(Rs1E),
        .Rs2E(Rs2E),
        .PCSrcE(PCSrcE),
        .ResultSrcE0(ResultSrcE0),
        .RdM(RdM),
        .RegWriteM(RegWriteM),
        .RdW(RdW),
        .RegWriteW(RegWriteW),
        .StallF(StallF),
        .StallD(StallD),
        .FlushD(FlushD),
        .FlushE(FlushE),
        .ForwardAE(ForwardAE),
        .ForwardBE(ForwardBE)
    );

endmodule