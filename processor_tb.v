`timescale 1ns/1ns

module processor_tb;

    reg clk;
    reg rst;

    processor cpu (
        .clk(clk),
        .rst(rst)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;

        #20;
        rst = 0;

        #2700;
        $display("x1: %d | x6: %d | x7: %d | x8: %d | x9: %d | x10: %d | x11: %d",  
            cpu.dp.reg_file.reg_array[1], 
            cpu.dp.reg_file.reg_array[6], 
            cpu.dp.reg_file.reg_array[7], 
            cpu.dp.reg_file.reg_array[8], 
            cpu.dp.reg_file.reg_array[9], 
            cpu.dp.reg_file.reg_array[10], 
            cpu.dp.reg_file.reg_array[11]
        );

        #100;
        $stop;
    end

endmodule