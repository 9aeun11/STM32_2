`timescale 1ns/1ps
module tb_task6_uart_echo;
    localparam integer DIV = 8;
    reg clk_50mhz = 0;
    reg rst_p = 1;
    reg uart_rxd = 1;
    wire uart_txd;
    wire [7:0] led;
    reg [7:0] observed;
    integer i;
    integer checks = 0;

    always #10 clk_50mhz = ~clk_50mhz;
    task6_uart_echo #(.CLK_HZ(800), .BAUD(100)) dut (
        .clk_50mhz(clk_50mhz), .rst_p(rst_p),
        .uart_rxd(uart_rxd), .uart_txd(uart_txd), .led(led)
    );

    task send_byte(input [7:0] value);
        begin
            @(negedge clk_50mhz);
            uart_rxd = 0;
            repeat (DIV) @(negedge clk_50mhz);
            for (i = 0; i < 8; i = i + 1) begin
                uart_rxd = value[i];
                repeat (DIV) @(negedge clk_50mhz);
            end
            uart_rxd = 1;
            repeat (DIV) @(negedge clk_50mhz);
        end
    endtask

    task receive_byte(input [7:0] expected);
        integer bit_index;
        begin
            observed = 0;
            @(negedge uart_txd);
            repeat (DIV + DIV/2) @(posedge clk_50mhz);
            for (bit_index = 0; bit_index < 8; bit_index = bit_index + 1) begin
                observed[bit_index] = uart_txd;
                repeat (DIV) @(posedge clk_50mhz);
            end
            if (observed !== expected)
                $fatal(1, "Task 6 echo got 0x%02h expected 0x%02h", observed, expected);
            if (led !== expected)
                $fatal(1, "Task 6 last received byte got 0x%02h expected 0x%02h", led, expected);
            checks = checks + 1;
            repeat (DIV) @(posedge clk_50mhz);
        end
    endtask

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_task6_uart_echo);
        repeat (4) @(posedge clk_50mhz);
        rst_p = 0;
        fork send_byte(8'h31); receive_byte(8'h31); join
        fork send_byte(8'h41); receive_byte(8'h41); join
        fork send_byte(8'h61); receive_byte(8'h61); join
        if (dut.rx_framing_error) $fatal(1, "Task 6 framing error");
        $display("PASS Task 6 UART 9600-8N1: 1/A/a echoed from FPGA to PC; checks=%0d", checks);
        $finish;
    end
    initial begin
        #50000;
        $fatal(1, "Task 6 timeout");
    end
endmodule
