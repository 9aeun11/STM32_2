`timescale 1ns/1ns
// Contract-level simulation of the Task 5 PC -> MCU -> PC byte behavior.
// This models the assignment's expected byte path; it does not execute STM32 firmware.
module tb;
    reg clk = 0;
    reg rst = 1;
    reg pc_valid = 0;
    reg [7:0] pc_byte = 0;
    reg echo_valid = 0;
    reg [7:0] echo_char = 0;
    reg [7:0] echo_hex = 0;
    reg [7:0] samples [0:2];
    integer i;

    always #5 clk = ~clk;
    task send_pc_byte(input [7:0] value);
        begin
            @(negedge clk);
            pc_byte = value;
            pc_valid = 1;
            @(posedge clk); #1;
            echo_char = pc_byte;
            echo_hex = pc_byte;
            echo_valid = 1;
            if (!echo_valid || echo_char !== value || echo_hex !== value)
                $fatal(1, "Task 5 echo mismatch for 0x%02X", value);
            @(negedge clk);
            pc_valid = 0;
            echo_valid = 0;
        end
    endtask

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb);
        samples[0] = 8'h31;
        samples[1] = 8'h41;
        samples[2] = 8'h61;
        repeat (2) @(negedge clk);
        rst = 0;
        for (i = 0; i < 3; i = i + 1)
            send_pc_byte(samples[i]);
        $display("PASS Task 5 model: PC -> MCU -> PC, 1/A/a = 0x31/0x41/0x61");
        $finish;
    end
    initial begin
        #1000;
        $fatal(1, "Task 5 timeout");
    end
endmodule
