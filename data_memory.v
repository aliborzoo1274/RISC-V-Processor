module data_memory (
    input clk,
    input [31:0] A,
    input WE,
    input [31:0] WD,
    output [31:0] RD
);

    wire [31:0] mem_addr;

    reg [31:0] mem_array [0:16384];

    initial begin
        $readmemb("data.txt", mem_array);
    end

    assign mem_addr = {2'b0, A[31:2]};

    always @(posedge clk) begin
        if (WE)
            mem_array[mem_addr] <= WD;
    end
    
    assign RD = mem_array[mem_addr];

endmodule