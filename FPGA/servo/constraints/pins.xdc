# Combo II-DLD-Base Xilinx S7 / xc7s75fgga484-1
# Source: Xilinx S7 Pin Map.pdf, pages 1-4 (course's new-equipment bundle).
# Each top-level port has a board signal and I/O standard.

set_property -dict { PACKAGE_PIN B6 IOSTANDARD LVCMOS33 } [get_ports {clk_50mhz}]
set_property -dict { PACKAGE_PIN N8 IOSTANDARD LVCMOS33 } [get_ports {rst_p}]
set_property -dict { PACKAGE_PIN K4 IOSTANDARD LVCMOS33 } [get_ports {left_button}]
set_property -dict { PACKAGE_PIN N4 IOSTANDARD LVCMOS33 } [get_ports {right_button}]
set_property -dict { PACKAGE_PIN AA22 IOSTANDARD LVCMOS33 } [get_ports {servo}]

create_clock -name clk_50mhz -period 20.000 [get_ports {clk_50mhz}]

