module hazard_unit (
    input [4:0] Rs1D,
    input [4:0] Rs2D,
    input [4:0] RdE,
    input [4:0] Rs1E,
    input [4:0] Rs2E,
    input [1:0] PCSrcE,
    input ResultSrcE0,
    input [4:0] RdM,
    input RegWriteM,
    input [4:0] RdW,
    input RegWriteW,
    output reg StallF,
    output reg StallD,
    output reg FlushD,
    output reg FlushE,
    output reg [1:0] ForwardAE,
    output reg [1:0] ForwardBE
);

    reg lwStall;

    always @(Rs1E, RdM, RdW, RegWriteM, RegWriteW) begin
        if (((Rs1E == RdM) && RegWriteM) && Rs1E != 5'b00000)
            ForwardAE = 2'b10;
        else if (((Rs1E == RdW) && RegWriteW) && Rs1E != 5'b00000)
            ForwardAE = 2'b01;
        else
            ForwardAE = 2'b00;
    end

    always @(Rs2E, RdM, RdW, RegWriteM, RegWriteW) begin
        if (((Rs2E == RdM) && RegWriteM) && Rs2E != 5'b00000)
            ForwardBE = 2'b10;
        else if (((Rs2E == RdW) && RegWriteW) && Rs2E != 5'b00000)
            ForwardBE = 2'b01;
        else
            ForwardBE = 2'b00;
    end

    always @(Rs1D, RdE, Rs2D, RdE, ResultSrcE0) begin
        if (((Rs1D == RdE) || (Rs2D == RdE)) && ResultSrcE0) begin
            lwStall = 1'b1;
            StallF = 1'b1;
            StallD = 1'b1;
        end
        else begin
            lwStall = 1'b0;
            StallF = 1'b0;
            StallD = 1'b0;
        end
    end

    always @(lwStall, PCSrcE) begin
        if (PCSrcE == 2'b01 || PCSrcE == 2'b10)
            FlushD = 1'b1;
        else
            FlushD = 1'b0;
        if (lwStall == 1'b1 || PCSrcE == 2'b01 || PCSrcE == 2'b10)
            FlushE = 1'b1;
        else
            FlushE = 1'b0;
    end

endmodule