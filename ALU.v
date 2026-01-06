`define ADD 3'b000
`define SUB 3'b001
`define AND 3'b010
`define OR 3'b011
`define SLT 3'b101

module ALU (
    input [31:0] a,
    input [31:0] b,
    input [2:0] sel,
    output reg [31:0] out,
    output zero
);

    always @(a, b, sel) begin
        out = 32'b0;
        case (sel)
            `ADD:
                out = a + b;
            `SUB:
                out = a - b;
            `AND:
                out = a & b;
            `OR:
                out = a | b;
            `SLT:
                out = (a < b ? 32'd1 : 32'd0);
            default: 
                out = 32'b0;
        endcase
    end

    assign zero = (out == 32'b0);

endmodule