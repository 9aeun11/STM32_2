`timescale 1ns/1ps
module tb_task7_uart_led;
    localparam integer DIV = 8;
    reg clk_50mhz = 0;
    reg rst_p = 1;
    reg uart_rxd = 1;
    wire uart_txd;
    wire led;
    reg [7:0] observed;
    integer i;
    integer checks = 0;

    always #10 clk_50mhz = ~clk_50mhz;
    task7_uart_led #(.CLK_HZ(800), .BAUD(100)) dut (
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
                $fatal(1, "Task 7 echo got 0x%02h expected 0x%02h", observed, expected);
            repeat (DIV) @(posedge clk_50mhz);
        end
    endtask

    task exercise(input [7:0] command, input expected_led);
        begin
            fork send_byte(command); receive_byte(command); join
            if (led !== expected_led)
                $fatal(1, "Task 7 command 0x%02h produced LED=%b expected %b", command, led, expected_led);
            checks = checks + 1;
        end
    endtask

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_task7_uart_led);
        repeat (4) @(posedge clk_50mhz);
        rst_p = 0;
        exercise(8'h31, 1'b1);
        exercise(8'h31, 1'b1);
        exercise(8'h32, 1'b0);
        exercise(8'h32, 1'b1);
        exercise(8'h30, 1'b0);
        exercise(8'h41, 1'b0);
        if (dut.rx_framing_error) $fatal(1, "Task 7 framing error");
        $display("PASS Task 7 UART LED: ASCII 0/1/2, repeated commands, unknown hold, FPGA USB-UART echo; checks=%0d", checks);
        $finish;
    end
    initial begin
        #50000;
        $fatal(1, "Task 7 timeout");
    end
endmodule
