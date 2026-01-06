module jmpinstr (
    input [1:0] JumpE,
    input [1:0] BranchE,
    input ZeroE,
    output reg [1:0] PCSrcE
);

    always @(JumpE, BranchE, ZeroE) begin
        if (JumpE == 2'b10) begin
            PCSrcE = 2'b10;
        end
        else if (JumpE == 2'b01 || (BranchE == 2'b01 && ZeroE) || (BranchE == 2'b10 && !ZeroE)) begin
            PCSrcE = 2'b01;
        end
        else begin
            PCSrcE = 2'b00;
        end
    end

endmodule