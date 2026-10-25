# STM32_2 실습 준비

이 폴더에는 교안 저장소의 NUCLEO-G474RE 제공 프로젝트와 STM32_2 실습용 코드가 들어 있습니다. 실습 순서는 과제 5 → 6 → 7이며 FPGA 개별 실습은 서보 → SRAM → DAC 순서입니다.

## VS Code / STM32

1. `ece2_474.code-workspace`를 VS Code에서 엽니다.
2. 교안대로 `STM32CubeIDE for Visual Studio Code` 확장과 `gnu-tools-for-stm32` 도구 묶음을 준비합니다.
3. CMake에서 `Debug`를 Configure한 뒤 Build합니다. 보드 JP5는 `5V_STLK`에 두고 ST-LINK USB를 연결합니다.
4. `Core/Src/ece2_474_routine.c`는 과제 5용으로 구성되어 있습니다. 과제 6·7은 `lab/task6_polling_routine.c`, `lab/task7_polling_routine.c`의 함수 본문으로 기존 `polling_routine()`을 교체해 진행합니다. 콜백과 함수 선언은 유지합니다.
5. 디버깅을 끝낸 뒤 F5로 새 프로그램을 보드에 다운로드하고, main에서 멈추면 F5를 다시 누릅니다.
6. Serial Monitor는 MCU VCP COM 포트를 열어 9600 baud, 8 data bits, no parity, 1 stop bit로 설정합니다. 과제 5에서 한 문자만 보낼 때 줄바꿈은 `None`입니다.

## 과제별 핵심 확인

| 과제 | 코드/신호 | 기대 결과 |
|---|---|---|
| 5 | 한 글자 입력 → MCU `printf` | `1`, `A`, `a`의 ASCII 값이 각각 `0x31`, `0x41`, `0x61` |
| 6 | PC10(TX) → FPGA RX, GND 공통 | MCU 송신 결과와 별도로 FPGA USB-UART COM에서 같은 문자 확인 |
| 7 | 수신 문자 ASCII `0`/`1`/`2` | LED 끄기/켜기/반전, 그 밖의 입력은 상태 유지 |

MCU는 제공 IOC의 PC10(TX), PC11(RX)를 사용하며 이 보드에는 MCU용 XDC가 없습니다. 과제 6은 한 방향만 검사하므로 MCU PC11 연결은 필요하지 않습니다. PC에는 MCU VCP와 FPGA USB-UART의 서로 다른 COM 포트를 각각 엽니다.

## Vivado / FPGA

`STM32_2` 폴더를 VS Code에서 열면 `Terminal → Run Task → STM32_2 FPGA: Simulate servo, SRAM, DAC`로 세 FPGA 개별 실습을 실행합니다. `FPGA/run_individual_fpga_simulations.tcl`이 Vivado 2026.1 XSim에서 세 프로젝트의 `tb`를 실행합니다. 결과 로그와 VCD는 각 실습의 `FPGA/<실습>/vivado/*.sim/sim_1/behav/xsim/` 아래에 저장됩니다. 별도로 `FPGA/STM32_2_FPGA.code-workspace`에는 네 프로젝트 전체 실행 작업도 있습니다.

STM32_2 문서 자체에는 주변장치 XDC가 없지만, `C:/Users/gaeun/Downloads/예전교안모음 (1)/02_신장비_교안/Lab-02 Data Flow Modeling/Xilinx S7 Pin Map.pdf`에서 현재 S7 보드의 서보·SRAM·DAC 핀표를 확인했습니다. 이를 `FPGA/<실습>/constraints/pins.xdc`에 적용했고 Vivado 2026.1에서 세 비트스트림을 모두 생성했습니다. 위치와 결과는 `FPGA/pin_assignment_status.md`에 적었습니다. 서보에는 기존 LAB3의 버튼 디바운스/한 클록 펄스 모듈을 연결했습니다. 서보·DAC를 보드에서 실행할 때 클록 선택기를 50 MHz로 맞춥니다. 실제 보드 다운로드와 동작 확인은 아직 수행하지 않았습니다.

## 코드 근거와 기준

- STM32 과제 5~7의 9600 8N1, PC10/PC11, UART2 `getchar()`와 UART3 송신 순서는 `docs/STM32_2.md` 및 `docs/index.md`를 따릅니다.
- FPGA 서보·SRAM·DAC 모듈과 테스트 항목은 `docs/FPGA_additional.md`의 STM32_2 섹션을 기준으로 구성했습니다.
- 사용 보드/템플릿은 저장소 README의 NUCLEO-G474RE와 제공 IOC 설정입니다. CubeMX 재생성은 하지 않습니다.

