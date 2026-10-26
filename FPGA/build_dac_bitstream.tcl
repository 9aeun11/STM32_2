# Register the existing board pin map in the DAC project and build its bitstream.
set root [file normalize [file dirname [info script]]]
set project_dir [file join $root dac vivado]
set xpr [file join $project_dir stm32_2_dac.xpr]
set xdc [file normalize [file join $root dac constraints pins.xdc]]
open_project $xpr

if {[llength [get_files -quiet -of_objects [get_filesets constrs_1] $xdc]] == 0} {
    add_files -fileset constrs_1 -norecurse $xdc
}
set_property PROCESSING_ORDER EARLY [get_files -of_objects [get_filesets constrs_1] $xdc]
update_compile_order -fileset constrs_1
reset_run impl_1
reset_run synth_1
launch_runs impl_1 -to_step write_bitstream
wait_on_run impl_1

set status [get_property STATUS [get_runs impl_1]]
puts "dac implementation status: $status"
if {![string match "*Complete!*" $status]} {
    error "DAC bitstream build did not complete: $status"
}

set outputs [glob -nocomplain [file join $project_dir stm32_2_dac.runs impl_1 *.bit]]
if {[llength $outputs] != 1} {
    error "Expected one DAC .bit output, found: $outputs"
}
set stable_dir [file join $root dac bitstream]
file mkdir $stable_dir
file copy -force [lindex $outputs 0] [file join $stable_dir [file tail [lindex $outputs 0]]]
puts "DAC bitstream saved to [file join $stable_dir [file tail [lindex $outputs 0]]]"
close_project
