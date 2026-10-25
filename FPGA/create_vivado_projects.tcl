# Creates one simulation-only Vivado project per STM32_2 FPGA exercise.
# The manual does not identify the FPGA board/part or expansion-header package pins.
# Select the exact part and add the RX pin constraint from the equipment pin map
# before synthesis or programming. No guessed XDC entries are added here.
set root [file normalize [file dirname [info script]]]
set labs [list \
    [list servo servo/rtl/servo_ctrl.v servo/sim/tb.sv] \
    [list sram sram/rtl/sram.v sram/sim/tb.sv] \
    [list dac dac/rtl/dac.v dac/sim/tb.sv] \
    [list uart_command uart_command/rtl/uart_led_command.v uart_command/sim/tb.sv]]

foreach lab $labs {
    lassign $lab name rtl tb
    set project_dir [file join $root $name vivado]
    file mkdir $project_dir
    create_project -force "stm32_2_${name}" $project_dir -part xc7s75fgga484-1
    add_files -fileset sources_1 [file join $root $rtl]
    add_files -fileset sim_1 [file join $root $tb]
    set_property top tb [get_filesets sim_1]
    set_property top_auto_set 0 [get_filesets sim_1]
    set_property xsim.simulate.runtime all [get_filesets sim_1]
    update_compile_order -fileset sources_1
    update_compile_order -fileset sim_1
    close_project
}
puts "Created four Vivado projects for xc7s75fgga484-1. Add peripheral XDC pin assignments from the equipment pin map before hardware use."
