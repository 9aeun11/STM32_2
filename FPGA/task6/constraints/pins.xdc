# Hanback Combo II-DLD S75, xc7s75fgga484-1.
# Pin source: Xilinx S7 Pin Map.pdf, pages 1, 4, 5 and 13.
# EX2 connector: EXT0 is physical pin 5; GND is physical pin 45/46/49/50.
# Connect STM32 PC10 (USART3 TX) to EX2 EXT0 and STM32 GND to EX2 GND.
set_property PACKAGE_PIN B6 [get_ports clk_50mhz]
set_property PACKAGE_PIN K4 [get_ports rst_p]
set_property PACKAGE_PIN G10 [get_ports uart_rxd]
set_property PACKAGE_PIN F6 [get_ports uart_txd]
set_property PACKAGE_PIN N5 [get_ports {led[0]}]
set_property PACKAGE_PIN M1 [get_ports {led[1]}]
set_property PACKAGE_PIN M3 [get_ports {led[2]}]
set_property PACKAGE_PIN M7 [get_ports {led[3]}]
set_property PACKAGE_PIN N7 [get_ports {led[4]}]
set_property PACKAGE_PIN M2 [get_ports {led[5]}]
set_property PACKAGE_PIN M4 [get_ports {led[6]}]
set_property PACKAGE_PIN L4 [get_ports {led[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports *]
create_clock -name clk_50mhz -period 20.000 [get_ports clk_50mhz]
set_false_path -from [get_ports {rst_p uart_rxd}]
