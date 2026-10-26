`timescale 1ns/1ps
// STM32_2 Task 7 board top: MCU UART -> command decoder and USB-UART echo.
module task7_uart_led #(
    parameter integer CLK_HZ = 50_000_000,
    parameter integer BAUD = 9_600
) (
    input wire clk_50mhz,
    input wire rst_p,
    input wire uart_rxd,
    output wire uart_txd,
    output wire led
);
    localparam integer DIV = (CLK_HZ + BAUD/2) / BAUD;
    wire [7:0] rx_data;
    wire rx_valid;
    wire rx_framing_error;
    wire tx_ready;
    wire rx_seen;
    wire [7:0] last_byte;
    reg tx_valid;
    reg [7:0] tx_data;

    uart_rx #(.DIV(DIV)) u_rx (
        .clk(clk_50mhz), .rst_p(rst_p), .rx(uart_rxd),
        .data(rx_data), .valid(rx_valid), .framing_error(rx_framing_error)
    );
    uart_led_command u_command (
        .clk_50mhz(clk_50mhz), .rst_p(rst_p),
        .rx_valid(rx_valid), .rx_data(rx_data),
        .led(led), .rx_seen(rx_seen), .last_byte(last_byte)
    );
    uart_tx #(.DIV(DIV)) u_tx (
        .clk(clk_50mhz), .rst_p(rst_p), .valid(tx_valid),
        .data(tx_data), .ready(tx_ready), .tx(uart_txd)
    );

    always @(posedge clk_50mhz or posedge rst_p) begin
        if (rst_p) begin
            tx_valid <= 0;
            tx_data <= 0;
        end else begin
            tx_valid <= 0;
            if (rx_valid && tx_ready) begin
                tx_data <= rx_data;
                tx_valid <= 1;
            end
        end
    end
endmodule
