set root [file normalize [file dirname [info script]]]
set projects [list \
    [file join $root servo vivado stm32_2_servo.xpr] \
    [file join $root sram vivado stm32_2_sram.xpr] \
    [file join $root dac vivado stm32_2_dac.xpr] \
    [file join $root task6 vivado stm32_2_task6.xpr] \
    [file join $root task7 vivado_final stm32_2_task7.xpr]]
foreach xpr $projects {
    open_project $xpr
    launch_simulation -simset sim_1 -mode behavioral
    run all
    close_sim
    close_project
}
puts "PASS: all five Vivado behavioral simulations completed."
