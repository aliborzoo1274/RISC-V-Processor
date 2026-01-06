module register_file (
    input clk,
    input rst,
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,
    input WE3,
    input [31:0] WD3,
    output [31:0] RD1,
    output [31:0] RD2
);

    integer i;
    reg [31:0] reg_array [0:31];

    initial begin
        reg_array[0] <= 32'b0;
    end

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1)
                reg_array[i] <= 32'b0;
        end
        else if (WE3 && A3 != 5'b0)
            reg_array[A3] <= WD3;
    end

    assign RD1 = reg_array[A1];
    assign RD2 = reg_array[A2];

endmodule