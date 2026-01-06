module extend (
    input [31:7] instr,
    input [2:0] ImmSrc,
    output [31:0] out
);
        
    assign out = 
        ImmSrc == 3'b000 ? {{21{instr[31]}}, instr[30:20]} : // I-Type
        ImmSrc == 3'b001 ? {{21{instr[31]}}, instr[30:25], instr[11:7]} : // S-Type
        ImmSrc == 3'b010 ? {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0} : // B-Type
        ImmSrc == 3'b011 ?  {{12{instr[31]}}, instr[19:12], instr[20], instr[30:25], instr[24:21], 1'b0} : // J-Type
        ImmSrc == 3'b100 ? {instr[31], instr[30:20], instr[19:12], 12'b0} : // U-Type
        32'bx;

endmodule