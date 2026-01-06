module instruction_memory (
    input [31:0] A,
    output [31:0] RD
);

    wire [31:0] mem_addr;
    reg [31:0] instr [0:16384];
    
    initial begin
        $readmemb("instructions.txt", instr);
    end

    assign mem_addr = {2'b0, A[31:2]};
    assign RD = instr[mem_addr];
        
endmodule