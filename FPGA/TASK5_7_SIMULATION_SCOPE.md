# Task 5–7 simulation scope

These simulations provide supplementary logic checks and waveforms for the requested assignments.

- Task 5 checks the byte/ASCII contract `PC -> MCU -> PC` at byte level. It does not execute the STM32 firmware or model UART pin timing. The assignment's actual evidence remains the MCU Serial Monitor output.
- Task 6 checks byte preservation across `PC -> MCU TX -> FPGA RX -> PC` at byte-valid stage level. It does not execute the STM32 firmware or model 9600-baud UART bits. The actual assignment still requires the two COM-port hardware check.
- Task 7 runs the project's `uart_led_command` RTL testbench. It checks ASCII `0`, `1`, and `2`, repeated commands, LED state, and unknown-command hold. UART serial decoding is outside this module's testbench; the bench drives the decoded byte interface.

From each task's simulation folder, compile and run with Icarus Verilog:

```powershell
iverilog -g2012 -s tb -o sim.out tb.sv
vvp .\sim.out | Tee-Object simulation.log
```

The run creates `wave.vcd` and `simulation.log`. Open `wave.vcd` in VS Code with VaporView. These supplementary simulations do not replace the hardware checks described in `docs/STM32_2.md`.
