module register #(
    parameter WIDTH = 32
)(
    input wire clk,
    input wire rst,
    input wire clr,
    input wire en,
    input wire [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);

    always @(posedge clk, posedge rst) begin
        if (rst || clr) begin
            q <= {WIDTH{1'b0}};
        end
        else if (en) begin
            q <= d;
        end
    end

endmodule