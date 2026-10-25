`timescale 1ns/1ns
// UART 수신기에서 받은 바이트와 1클록 rx_valid 펄스를 연결합니다.
// UART 직렬 수신·PC 출력 경로는 기존 LAB3 UART 예제에 연결합니다.
module uart_led_command(
    input wire clk_50mhz,rst_p,
    input wire rx_valid,
    input wire [7:0] rx_data,
    output reg led,
    output reg rx_seen,
    output reg [7:0] last_byte
);
    always @(posedge clk_50mhz) begin
        if(rst_p) begin
            led<=0;
            rx_seen<=0;
            last_byte<=0;
        end else begin
            rx_seen<=0;
            if(rx_valid) begin
                last_byte<=rx_data;
                rx_seen<=1;
                case(rx_data)
                    8'h30: led<=0;       // ASCII '0': LED off
                    8'h31: led<=1;       // ASCII '1': LED on
                    8'h32: led<=~led;    // ASCII '2': toggle LED
                    default: led<=led;
                endcase
            end
        end
    end
endmodule
