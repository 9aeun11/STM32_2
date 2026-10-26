# Task 5–7 simulation scope

These simulations provide supplementary logic checks and waveforms for the requested assignments.

- Task 5 checks the byte/ASCII contract `PC -> MCU -> PC` at byte level. It does not execute the STM32 firmware or model UART pin timing. The assignment's actual evidence remains the MCU Serial Monitor output.
- The original `task6_sim` model checks byte preservation only. The complete `task6` Vivado project simulates FPGA UART serial RX and USB-UART echo, then generates a pin-constrained bitstream. The actual assignment still requires the two COM-port hardware check.
- The original Task 7 `uart_led_command` unit test drives decoded bytes. The complete `task7/vivado_final` project includes UART serial RX/TX, LED command decoding, pin constraints, and a full serial testbench.

From each task's simulation folder, compile and run with Icarus Verilog:

```powershell
iverilog -g2012 -s tb -o sim.out tb.sv
vvp .\sim.out | Tee-Object simulation.log
```

The run creates `wave.vcd` and `simulation.log`. Open `wave.vcd` in VS Code with VaporView. These supplementary simulations do not replace the hardware checks described in `docs/STM32_2.md`.

