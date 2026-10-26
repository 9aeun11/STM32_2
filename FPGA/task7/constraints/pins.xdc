# Hanback Combo II-DLD S75, xc7s75fgga484-1.
# Source: Xilinx S7 Pin Map.pdf, pages 1, 4, 5 and 13.
# STM32 PC10 TX -> FPGA EX2 EXT0 (physical connector pin 5, chip G10).
# STM32 GND -> FPGA EX2 GND (connector pin 45/46/49/50).
set_property PACKAGE_PIN B6 [get_ports clk_50mhz]
set_property PACKAGE_PIN K4 [get_ports rst_p]
set_property PACKAGE_PIN G10 [get_ports uart_rxd]
set_property PACKAGE_PIN F6 [get_ports uart_txd]
set_property PACKAGE_PIN N5 [get_ports led]
set_property IOSTANDARD LVCMOS33 [get_ports *]
create_clock -name clk_50mhz -period 20.000 [get_ports clk_50mhz]
set_false_path -from [get_ports {rst_p uart_rxd}]
