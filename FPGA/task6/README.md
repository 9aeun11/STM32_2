# STM32_2 과제 6 · MCU → FPGA → PC

교안 `docs/STM32_2.md` 과제 6과 LAB3 UART 에코 회로를 사용합니다. FPGA는 MCU USART3의 문자를 9600 8N1로 받은 뒤 보드 USB-UART TX로 같은 문자를 보냅니다. `1`, `A`, `a`의 직렬 수신·송신을 시뮬레이션으로 확인합니다.

## 연결

- STM32 PC10 (USART3 TX) → FPGA **EX2 EXT0 (커넥터 5번, 칩 G10)**
- STM32 GND → FPGA **EX2 GND (커넥터 45/46/49/50번 중 하나)**
- FPGA USB-UART TX → 칩 F6 (보드 내부 연결)
- FPGA 클록 50 MHz, 모든 UART 9600 8N1

핀 번호는 수업 자료 `Xilinx S7 Pin Map.pdf`의 1·4·5·13쪽을 근거로 지정했습니다. KEY01(K4)은 리셋입니다. `led[7:0]`은 마지막 수신 바이트를 보조 표시합니다.

## Vivado

`vivado/stm32_2_task6.xpr`을 열어 시뮬레이션과 bitstream을 확인합니다. 재생성·빌드는 `vivado.bat -mode batch -source create_and_build.tcl`로 실행합니다. 완성된 bitstream은 `vivado/stm32_2_task6.runs/impl_1/task6_uart_echo.bit`입니다.

실제 과제 확인은 MCU VCP와 FPGA USB-UART의 **서로 다른 COM 포트**를 열고 MCU 쪽으로 문자를 보내 FPGA 쪽에서 같은 문자가 나오는지 확인해야 합니다. 시뮬레이션은 FPGA UART 경로를 검증하며 보드 간 점퍼선과 COM 포트 동작을 대신하지 않습니다.
