# Combo II-DLD-Base Xilinx S7 / xc7s75fgga484-1
# Source: Xilinx S7 Pin Map.pdf, pages 1-4 (course's new-equipment bundle).
# Each top-level port has a board signal and I/O standard.

set_property -dict { PACKAGE_PIN B6 IOSTANDARD LVCMOS33 } [get_ports {clk_50mhz}]
set_property -dict { PACKAGE_PIN K4 IOSTANDARD LVCMOS33 } [get_ports {rst_p}]
set_property -dict { PACKAGE_PIN Y1 IOSTANDARD LVCMOS33 } [get_ports {add_sel}]
set_property -dict { PACKAGE_PIN G2 IOSTANDARD LVCMOS33 } [get_ports {dac_a_b}]
set_property -dict { PACKAGE_PIN E1 IOSTANDARD LVCMOS33 } [get_ports {dac_csn}]
set_property -dict { PACKAGE_PIN F4 IOSTANDARD LVCMOS33 } [get_ports {dac_ldacn}]
set_property -dict { PACKAGE_PIN G4 IOSTANDARD LVCMOS33 } [get_ports {dac_wen}]
set_property -dict { PACKAGE_PIN E3 IOSTANDARD LVCMOS33 } [get_ports {dac_d[0]}]
set_property -dict { PACKAGE_PIN E5 IOSTANDARD LVCMOS33 } [get_ports {dac_d[1]}]
set_property -dict { PACKAGE_PIN D2 IOSTANDARD LVCMOS33 } [get_ports {dac_d[2]}]
set_property -dict { PACKAGE_PIN D5 IOSTANDARD LVCMOS33 } [get_ports {dac_d[3]}]
set_property -dict { PACKAGE_PIN C2 IOSTANDARD LVCMOS33 } [get_ports {dac_d[4]}]
set_property -dict { PACKAGE_PIN C4 IOSTANDARD LVCMOS33 } [get_ports {dac_d[5]}]
set_property -dict { PACKAGE_PIN B1 IOSTANDARD LVCMOS33 } [get_ports {dac_d[6]}]
set_property -dict { PACKAGE_PIN B3 IOSTANDARD LVCMOS33 } [get_ports {dac_d[7]}]
set_property -dict { PACKAGE_PIN N5 IOSTANDARD LVCMOS33 } [get_ports {led_out[0]}]
set_property -dict { PACKAGE_PIN M1 IOSTANDARD LVCMOS33 } [get_ports {led_out[1]}]
set_property -dict { PACKAGE_PIN M3 IOSTANDARD LVCMOS33 } [get_ports {led_out[2]}]
set_property -dict { PACKAGE_PIN M7 IOSTANDARD LVCMOS33 } [get_ports {led_out[3]}]
set_property -dict { PACKAGE_PIN N7 IOSTANDARD LVCMOS33 } [get_ports {led_out[4]}]
set_property -dict { PACKAGE_PIN M2 IOSTANDARD LVCMOS33 } [get_ports {led_out[5]}]
set_property -dict { PACKAGE_PIN M4 IOSTANDARD LVCMOS33 } [get_ports {led_out[6]}]
set_property -dict { PACKAGE_PIN L4 IOSTANDARD LVCMOS33 } [get_ports {led_out[7]}]

create_clock -name clk_50mhz -period 20.000 [get_ports {clk_50mhz}]

