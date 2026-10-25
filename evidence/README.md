# STM32_2 evidence

Screenshots are named by task, signal, or result so the matching evidence is clear.

## MCU tasks 5–7

| Task | VS Code code | Simulation PASS | Waveform |
|---|---|---|---|
| 5 | [Code-Task5-MCU.png](Code-Task5-MCU.png) | [Task5-Simulation-Log.png](Task5-Simulation-Log.png) | [Task5-Waveform-ns.png](Task5-Waveform-ns.png) |
| 6 | [Code-Task6-MCU.png](Code-Task6-MCU.png) | [Task6-Simulation-Log.png](Task6-Simulation-Log.png) | [Task6-Waveform-ns.png](Task6-Waveform-ns.png) |
| 7 | [Code-Task7-MCU.png](Code-Task7-MCU.png) | [Task7-Simulation-Log.png](Task7-Simulation-Log.png) | [Task7-Waveform-ns.png](Task7-Waveform-ns.png) |

[Code-UART-RX-Callback.png](Code-UART-RX-Callback.png) shows the MCU UART receive callback. It was previously mislabeled as an FPGA code screenshot.

## FPGA supplemental simulations

- Servo: [PASS log](pass_servo.png), [VaporView waveform in ns](wave_servo_ns.png).
- SRAM: [PASS log](pass_sram.png), [VaporView waveform in ps](wave_sram_ps.png). The current SRAM screenshot uses ps units.
- DAC: [Vivado XSim PASS log](pass_dac.png), [Icarus PASS log](pass_dac_iverilog.png), [VaporView waveform in ns](wave_dac_ns.png), and [older Vivado waveform view in us](wave_dac_vivado_us.png).
- [Timing summary](timing_summary_no_constraints.png) reports no user timing constraints; it is not timing-closure evidence.

The Vivado and Icarus source projects, testbenches, pin constraints, and simulation logs are in `../FPGA/`.
