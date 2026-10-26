# STM32_2 과제 7 · UART 명령으로 FPGA LED 제어

Vivado에서 **`vivado_final/stm32_2_task7.xpr`**을 엽니다. 이전 `vivado/stm32_2_uart_command.xpr`은 명령 해석 모듈만 합성해 `rx_valid`와 `rx_data[7:0]`를 외부 핀으로 취급했습니다. 이 완성 프로젝트는 LAB3의 UART 수신·송신기와 명령 해석 모듈을 연결합니다.

## 핀과 연결

- STM32 PC10 (USART3 TX) → FPGA EX2 EXT0 (커넥터 5번, 칩 G10)
- STM32 GND → FPGA EX2 GND (커넥터 45/46/49/50번 중 하나)
- FPGA USB-UART TX F6 → PC 출력
- FPGA 클록 B6(50 MHz), KEY01 리셋 K4, LED_D8 N5
- UART 9600 8N1, `LVCMOS33`

핀 출처는 수업 자료 `Xilinx S7 Pin Map.pdf`의 1·4·5·13쪽입니다. 과제 6과 같은 점퍼선 연결을 사용합니다.

`'0'`은 LED 끄기, `'1'`은 켜기, `'2'`는 반전, 다른 문자는 유지합니다. 받은 문자는 USB-UART를 통해 PC에 다시 출력합니다. `sim/tb_task7_uart_led.sv`는 직렬 UART 프레임으로 명령을 보내고 LED 및 에코를 검증합니다. 시뮬레이션 속도를 위해 테스트벤치의 클록/baud 매개변수만 축소합니다. 실제 합성 상위 모듈은 50 MHz/9600 baud입니다.

프로젝트 재생성 및 빌드: `vivado.bat -mode batch -source create_and_build.tcl`. 비트스트림은 `vivado_final/stm32_2_task7.runs/impl_1/task7_uart_led.bit`입니다. 실제 보드의 LED·두 COM 포트 동작은 장비에 다운로드하고 확인해야 합니다.
