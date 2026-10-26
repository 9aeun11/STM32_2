set root [file normalize [file dirname [info script]]]
set project_dir [file join $root vivado_final]
file mkdir $project_dir
create_project -force stm32_2_task7 $project_dir -part xc7s75fgga484-1
add_files -fileset sources_1 [file join $root rtl uart.v]
add_files -fileset sources_1 [file join $root rtl uart_led_command.v]
add_files -fileset sources_1 [file join $root rtl task7_uart_led.v]
add_files -fileset constrs_1 [file join $root constraints pins.xdc]
add_files -fileset sim_1 [file join $root sim tb_task7_uart_led.sv]
set_property top task7_uart_led [get_filesets sources_1]
set_property top tb_task7_uart_led [get_filesets sim_1]
set_property top_auto_set 0 [get_filesets sim_1]
set_property xsim.simulate.runtime all [get_filesets sim_1]
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
launch_simulation -simset sim_1 -mode behavioral
run all
close_sim
launch_runs impl_1 -to_step write_bitstream
wait_on_run impl_1
set run [get_runs impl_1]
puts "TASK7_IMPL_STATUS=[get_property STATUS $run]"
puts "TASK7_IMPL_PROGRESS=[get_property PROGRESS $run]"
close_project
