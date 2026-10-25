`timescale 1ns/1ns
// Contract-level simulation of the Task 6 byte route.
// The PC/MCU/FPGA path is modeled at byte level, not UART pin timing.
module task6_byte_route(
    input wire clk,
    input wire rst,
    input wire start,
    input wire [7:0] pc_byte,
    output reg [1:0] stage,
    output reg [7:0] route_byte
);
    always @(posedge clk) begin
        if (rst) begin
            stage <= 0;
            route_byte <= 0;
        end else if (start) begin
            stage <= 1; // MCU received the PC byte and starts UART3 TX.
            route_byte <= pc_byte;
        end else if (stage != 0) begin
            if (stage == 3) stage <= 0;
            else stage <= stage + 1'b1;
        end
    end
endmodule

module tb;
    reg clk = 0;
    reg rst = 1;
    reg start = 0;
    reg [7:0] pc_byte = 0;
    wire [1:0] stage;
    wire [7:0] route_byte;
    reg [7:0] samples [0:2];
    integer i;

    always #5 clk = ~clk;
    task6_byte_route dut(clk, rst, start, pc_byte, stage, route_byte);

    task send_byte(input [7:0] value);
        begin
            @(negedge clk);
            pc_byte = value;
            start = 1;
            @(posedge clk); #1;
            if (stage !== 1 || route_byte !== value)
                $fatal(1, "Task 6 MCU TX stage mismatch for 0x%02X", value);
            @(negedge clk); start = 0;
            @(posedge clk); #1;
            if (stage !== 2 || route_byte !== value)
                $fatal(1, "Task 6 FPGA RX stage mismatch for 0x%02X", value);
            @(posedge clk); #1;
            if (stage !== 3 || route_byte !== value)
                $fatal(1, "Task 6 PC output stage mismatch for 0x%02X", value);
            @(posedge clk); #1;
            if (stage !== 0)
                $fatal(1, "Task 6 route did not return idle");
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
            send_byte(samples[i]);
        $display("PASS Task 6 model: PC -> MCU TX -> FPGA RX -> PC, 1/A/a preserved");
        $finish;
    end
    initial begin
        #1000;
        $fatal(1, "Task 6 timeout");
    end
endmodule
