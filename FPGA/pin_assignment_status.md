# FPGA pin assignment and bitstream status

- Board/part: Hanback Combo II-DLD S75, `xc7s75fgga484-1`.
- Pin source: `C:/Users/gaeun/Downloads/예전교안모음 (1)/02_신장비_교안/Lab-02 Data Flow Modeling/Xilinx S7 Pin Map.pdf`, pages 1–4. Its clock, key, and LED pins agree with the existing LAB2 XDC.
- `servo/constraints/pins.xdc`: clock B6, reset KEY01/K4, left/right KEY02/N8 and KEY03/N4, servo AA22. The synthesis top is `servo_board`, which reuses the LAB3 `button_onepulse` module.
- `sram/constraints/pins.xdc`: KEY02/KEY03 write/read, DIP_SW1–8 for address/data input, all 18 SRAM address pins, 16 data pins, 3 control pins, and 8 LEDs.
- `dac/constraints/pins.xdc`: clock B6, reset KEY01/K4, channel DIP_SW1/Y1, all DAC control/data pins, and 8 LEDs.
- All mapped FPGA ports use `LVCMOS33`; the 50 MHz clocked designs have 20 ns timing constraints.

Vivado 2026.1 completed `write_bitstream` for all three projects, with 0 DRC errors:

| Design | Bitstream | Result |
|---|---|---|
| Servo | `servo/vivado/stm32_2_servo.runs/impl_1/servo_board.bit` | Complete, 50 MHz routed WNS +13.174 ns |
| SRAM | `sram/vivado/stm32_2_sram.runs/impl_1/sram.bit` | Complete; combinational design has no clock timing constraint |
| DAC | `dac/vivado/stm32_2_dac.runs/impl_1/dac.bit` | Complete |

Servo XSim was rerun after simplifying the 50 MHz pulse-width calculation and still reports PASS. The board wrapper was also tested with `sim/tb_servo_board.sv` in Icarus Verilog: holding a key causes one step and release rearms it. The bits have not been programmed onto the board. Set the board clock selector to 50 MHz for servo and DAC.
