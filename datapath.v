module datapath (
    input clk,
    input rst,
    input RegWriteD,
    input [1:0] ResultSrcD,
    input MemWriteD,
    input [1:0] JumpD,
    input [1:0] BranchD,
    input [2:0] ALUControlD,
    input ALUSrcD,
    input [2:0] ImmSrcD,
    input LUID,
    input StallF,
    input StallD,
    input FlushD,
    input FlushE,
    input [1:0] ForwardAE,
    input [1:0] ForwardBE,
    output [6:0] op,
    output [2:0] funct3,
    output funct75,
    output wire [4:0] Rs1D,
    output wire [4:0] Rs2D,
    output [4:0] Rs1E,
    output [4:0] Rs2E,
    output wire [4:0] RdE,
    output wire [1:0] PCSrcE,
    output ResultSrcE0,
    output wire [4:0] RdM,
    output wire RegWriteM,
    output wire [4:0] RdW,
    output wire RegWriteW
);

    wire [31:0] PCPlus4F;
    wire [31:0] PCTargetE;
    wire [31:0] ALUResultE;
    wire [31:0] PCf;
    wire [31:0] PCF;
    wire [31:0] InstrF;
    wire [31:0] InstrD;
    wire [31:0] PCD;
    wire [31:0] PCPlus4D;
    wire [4:0] RdD;
    wire [31:0] ResultW;
    wire [31:0] RD1D;
    wire [31:0] RD2D;
    wire [31:0] ExtImmD;
    wire RegWriteE;
    wire [1:0] ResultSrcE;
    wire MemWriteE;
    wire [1:0] JumpE;
    wire [1:0] BranchE;
    wire [2:0] ALUControlE;
    wire ALUSrcE;
    wire LUIE;
    wire [31:0] RD1E;
    wire [31:0] RD2E;
    wire [31:0] PCE;
    wire [31:0] ExtImmE;
    wire [31:0] PCPlus4E;
    wire ZeroE;
    wire [31:0] ALUResultM;
    wire [31:0] SrcAE;
    wire [31:0] SrcBE;
    wire [31:0] WriteDataE;
    wire [1:0] ResultSrcM;
    wire MemWriteM;
    wire LUIM;
    wire [31:0] WriteDataM;
    wire [31:0] ExtImmM;
    wire [31:0] PCPlus4M;
    wire [31:0] ReadDataM;
    wire [31:0] ForwardingData;
    wire [1:0] ResultSrcW;
    wire [31:0] ALUResultW;
    wire [31:0] ReadDataW;
    wire [31:0] ExtImmW;
    wire [31:0] PCPlus4W;

    mux4to1 m1 (
        .in0(PCPlus4F),
        .in1(PCTargetE),
        .in2(ALUResultE),
        .in3(32'bx),
        .sel(PCSrcE),
        .out(PCf)
    );

    register PC (
        .clk(clk),
        .rst(rst),
        .clr(1'b0),
        .en(~StallF),
        .d(PCf),
        .q(PCF)
    );

    instruction_memory instr_mem (
        .A(PCF),
        .RD(InstrF)
    );

    adder plus4adder (
        .a(PCF),
        .b(32'd4),
        .s(PCPlus4F)
    );

    register fd1 (
        .clk(clk),
        .rst(rst),
        .clr(FlushD),
        .en(~StallD),
        .d(InstrF),
        .q(InstrD)
    );

    register fd2 (
        .clk(clk),
        .rst(rst),
        .clr(FlushD),
        .en(~StallD),
        .d(PCF),
        .q(PCD)
    );

    register fd3 (
        .clk(clk),
        .rst(rst),
        .clr(FlushD),
        .en(~StallD),
        .d(PCPlus4F),
        .q(PCPlus4D)
    );

    register_file reg_file (
        .clk(~clk),
        .rst(rst),
        .A1(InstrD[19:15]),
        .A2(InstrD[24:20]),
        .A3(RdW),
        .WE3(RegWriteW),
        .WD3(ResultW),
        .RD1(RD1D),
        .RD2(RD2D)
    );

    extend ext (
        .instr(InstrD[31:7]),
        .ImmSrc(ImmSrcD),
        .out(ExtImmD)
    );

    register #(.WIDTH(1)) de1 (
        .clk(clk),
        .rst(rst),
        .clr(FlushE),
        .en(1'b1),
        .d(RegWriteD),
        .q(RegWriteE)
    );

    register #(.WIDTH(2)) de2 (
        .clk(clk),
        .rst(rst),
        .clr(FlushE),
        .en(1'b1),
        .d(ResultSrcD),
        .q(ResultSrcE)
    );

    register #(.WIDTH(1)) de3 (
        .clk(clk),
        .rst(rst),
        .clr(FlushE),
        .en(1'b1),
        .d(MemWriteD),
        .q(MemWriteE)
    );

    register #(.WIDTH(2)) de4 (
        .clk(clk),
        .rst(rst),
        .clr(FlushE),
        .en(1'b1),
        .d(JumpD),
        .q(JumpE)
    );

    register #(.WIDTH(2)) de5 (
        .clk(clk),
        .rst(rst),
        .clr(FlushE),
        .en(1'b1),
        .d(BranchD),
        .q(BranchE)
    );

    register #(.WIDTH(3)) de6 (
        .clk(clk),
        .rst(rst),
        .clr(FlushE),
        .en(1'b1),
        .d(ALUControlD),
        .q(ALUControlE)
    );

    register #(.WIDTH(1)) de7 (
        .clk(clk),
        .rst(rst),
        .clr(FlushE),
        .en(1'b1),
        .d(ALUSrcD),
        .q(ALUSrcE)
    );

    register  #(.WIDTH(1)) de8 (
        .clk(clk),
        .rst(rst),
        .clr(FlushE),
        .en(1'b1),
        .d(LUID),
        .q(LUIE)
    );

    register de9 (
        .clk(clk),
        .rst(rst),
        .clr(FlushE),
        .en(1'b1),
        .d(RD1D),
        .q(RD1E)
    );

    register de10 (
        .clk(clk),
        .rst(rst),
        .clr(FlushE),
        .en(1'b1),
        .d(RD2D),
        .q(RD2E)
    );

    register de11 (
        .clk(clk),
        .rst(rst),
        .clr(FlushE),
        .en(1'b1),
        .d(PCD),
        .q(PCE)
    );

    register #(.WIDTH(5)) de12 (
        .clk(clk),
        .rst(rst),
        .clr(FlushE),
        .en(1'b1),
        .d(Rs1D),
        .q(Rs1E)
    );

    register #(.WIDTH(5)) de13 (
        .clk(clk),
        .rst(rst),
        .clr(FlushE),
        .en(1'b1),
        .d(Rs2D),
        .q(Rs2E)
    );

    register #(.WIDTH(5)) de14 (
        .clk(clk),
        .rst(rst),
        .clr(FlushE),
        .en(1'b1),
        .d(RdD),
        .q(RdE)
    );

    register de15 (
        .clk(clk),
        .rst(rst),
        .clr(FlushE),
        .en(1'b1),
        .d(ExtImmD),
        .q(ExtImmE)
    );

    register de16 (
        .clk(clk),
        .rst(rst),
        .clr(FlushE),
        .en(1'b1),
        .d(PCPlus4D),
        .q(PCPlus4E)
    );

    jmpinstr jinstr (
        .JumpE(JumpE),
        .BranchE(BranchE),
        .ZeroE(ZeroE),
        .PCSrcE(PCSrcE)
    );

    mux4to1 m2 (
        .in0(RD1E),
        .in1(ResultW),
        .in2(ForwardingData),
        .in3(32'bx),
        .sel(ForwardAE),
        .out(SrcAE)
    );

    mux4to1 m3 (
        .in0(RD2E),
        .in1(ResultW),
        .in2(ForwardingData),
        .in3(32'bx),
        .sel(ForwardBE),
        .out(WriteDataE)
    );

    mux2to1 m4 (
        .in0(WriteDataE),
        .in1(ExtImmE),
        .sel(ALUSrcE),
        .out(SrcBE)
    );

    ALU alu (
        .a(SrcAE),
        .b(SrcBE),
        .sel(ALUControlE),
        .out(ALUResultE),
        .zero(ZeroE)
    );

    adder jmpadder (
        .a(PCE),
        .b(ExtImmE),
        .s(PCTargetE)
    );

    register #(.WIDTH(1)) em1 (
        .clk(clk),
        .rst(rst),
        .clr(1'b0),
        .en(1'b1),
        .d(RegWriteE),
        .q(RegWriteM)
    );

    register #(.WIDTH(2)) em2 (
        .clk(clk),
        .rst(rst),
        .clr(1'b0),
        .en(1'b1),
        .d(ResultSrcE),
        .q(ResultSrcM)
    );

    register #(.WIDTH(1)) em3 (
        .clk(clk),
        .rst(rst),
        .clr(1'b0),
        .en(1'b1),
        .d(MemWriteE),
        .q(MemWriteM)
    );

    register #(.WIDTH(1)) em4 (
        .clk(clk),
        .rst(rst),
        .clr(1'b0),
        .en(1'b1),
        .d(LUIE),
        .q(LUIM)
    );

    register em5 (
        .clk(clk),
        .rst(rst),
        .clr(1'b0),
        .en(1'b1),
        .d(ALUResultE),
        .q(ALUResultM)
    );

    register em6 (
        .clk(clk),
        .rst(rst),
        .clr(1'b0),
        .en(1'b1),
        .d(WriteDataE),
        .q(WriteDataM)
    );

    register #(.WIDTH(5)) em7 (
        .clk(clk),
        .rst(rst),
        .clr(1'b0),
        .en(1'b1),
        .d(RdE),
        .q(RdM)
    );

    register em8 (
        .clk(clk),
        .rst(rst),
        .clr(1'b0),
        .en(1'b1),
        .d(ExtImmE),
        .q(ExtImmM)
    );

    register em9 (
        .clk(clk),
        .rst(rst),
        .clr(1'b0),
        .en(1'b1),
        .d(PCPlus4E),
        .q(PCPlus4M)
    );

    data_memory data_mem (
        .clk(clk),
        .A(ALUResultM),
        .WE(MemWriteM),
        .WD(WriteDataM),
        .RD(ReadDataM)
    );

    mux2to1 m5 (
        .in0(ALUResultM),
        .in1(ExtImmM),
        .sel(LUIM),
        .out(ForwardingData)
    );

    register #(.WIDTH(1)) mw1 (
        .clk(clk),
        .rst(rst),
        .clr(1'b0),
        .en(1'b1),
        .d(RegWriteM),
        .q(RegWriteW)
    );

    register #(.WIDTH(2)) mw2 (
        .clk(clk),
        .rst(rst),
        .clr(1'b0),
        .en(1'b1),
        .d(ResultSrcM),
        .q(ResultSrcW)
    );

    register mw3 (
        .clk(clk),
        .rst(rst),
        .clr(1'b0),
        .en(1'b1),
        .d(ALUResultM),
        .q(ALUResultW)
    );

    register mw4 (
        .clk(clk),
        .rst(rst),
        .clr(1'b0),
        .en(1'b1),
        .d(ReadDataM),
        .q(ReadDataW)
    );

    register #(.WIDTH(5)) mw5 (
        .clk(clk),
        .rst(rst),
        .clr(1'b0),
        .en(1'b1),
        .d(RdM),
        .q(RdW)
    );

    register mw6 (
        .clk(clk),
        .rst(rst),
        .clr(1'b0),
        .en(1'b1),
        .d(ExtImmM),
        .q(ExtImmW)
    );

    register mw7 (
        .clk(clk),
        .rst(rst),
        .clr(1'b0),
        .en(1'b1),
        .d(PCPlus4M),
        .q(PCPlus4W)
    );

    mux4to1 m6 (
        .in0(ALUResultW),
        .in1(ReadDataW),
        .in2(PCPlus4W),
        .in3(ExtImmW),
        .sel(ResultSrcW),
        .out(ResultW)
    );

    assign op = InstrD[6:0];
    assign funct3 = InstrD[14:12];
    assign funct75 = InstrD[30];
    assign Rs1D = InstrD[19:15];
    assign Rs2D = InstrD[24:20];
    assign RdD = InstrD[11:7];
    assign ResultSrcE0 = ResultSrcE[0];

endmodule