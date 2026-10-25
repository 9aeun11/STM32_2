set root [file normalize [file dirname [info script]]]
set labs {servo sram dac uart_command}
foreach name $labs {
    set xpr [file join $root $name vivado "stm32_2_${name}.xpr"]
    open_project $xpr
    launch_simulation -simset sim_1 -mode behavioral
    run all
    close_sim
    close_project
}
puts "PASS: all four Vivado behavioral simulations completed."
