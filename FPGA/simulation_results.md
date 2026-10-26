# Vivado XSim results

Simulator: Vivado 2026.1 behavioral XSim. Each testbench uses a shortened clock parameter for simulation and calls `$fatal` if a checked result is wrong.

| Project | PASS result | Simulated finish time |
|---|---|---:|
| `servo` | 20 ms frame, 1/1.5/2 ms pulse widths, limits, reset | 100036 ns |
| `sram` | 16 addresses, released bus, simultaneous request ignored | 164 ns |
| `dac` | 260 writes, 255→0 wrap, channel change, data hold, reset | 10436 ns |
| `task6` complete UART | 1/A/a received serially and echoed through USB-UART | 9970 ns |
| `task7/vivado_final` | Serial ASCII 0/1/2, repeats, unknown hold, LED state, USB-UART echo | 19870 ns |

Vivado writes full transcripts and `.wdb`/`.vcd` traces under each lab's ignored `vivado/*.sim/` build folder when the simulations run. Full transcripts and VCD waveforms are generated under each Vivado simulation output folder.

These are RTL functional simulations. Existing LAB2/LAB3 course files identify the Combo II-DLD S75 part as `xc7s75fgga484-1`, and the Vivado projects use that part. The peripheral package pins were assigned from the new-equipment `Xilinx S7 Pin Map.pdf` in the downloaded course bundle; see `pin_assignment_status.md`. Vivado synthesis and bitstream generation completed for servo, SRAM, DAC, Task 6, and Task 7. The complete Task 6/7 projects have pin constraints from the equipment map. Board programming and hardware operation have not been checked. Servo XSim was rerun after the timing fix and still reports PASS. The servo board wrapper additionally passed `sim/tb_servo_board.sv` in Icarus Verilog, checking held-key one-pulse behavior.


