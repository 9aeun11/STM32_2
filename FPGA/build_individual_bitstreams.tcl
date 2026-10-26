# Rebuild bitstreams for the three STM32_2 supplemental FPGA exercises.
set root [file normalize [file dirname [info script]]]
set labs [list servo sram dac]

foreach name $labs {
    set project_dir [file join $root $name vivado]
    set xpr [file join $project_dir "stm32_2_${name}.xpr"]
    if {![file exists $xpr]} {
        error "Missing Vivado project: $xpr"
    }

    open_project $xpr
    set xdc [file normalize [file join $root $name constraints pins.xdc]]
    if {[file exists $xdc] && [llength [get_files -quiet -of_objects [get_filesets constrs_1] $xdc]] == 0} {
        add_files -fileset constrs_1 -norecurse $xdc
    }
    reset_run impl_1
    reset_run synth_1
    launch_runs impl_1 -to_step write_bitstream
    wait_on_run impl_1

    set status [get_property STATUS [get_runs impl_1]]
    puts "$name implementation status: $status"
    if {![string match "*Complete!*" $status]} {
        error "$name bitstream build did not complete: $status"
    }

    set outputs [glob -nocomplain [file join $project_dir "stm32_2_${name}.runs" impl_1 *.bit]]
    if {[llength $outputs] != 1} {
        error "Expected one .bit output for $name, found: $outputs"
    }
    set stable_dir [file join $root $name bitstream]
    file mkdir $stable_dir
    set output_name [file tail [lindex $outputs 0]]
    file copy -force [lindex $outputs 0] [file join $stable_dir $output_name]
    puts "$name bitstream saved to [file join $stable_dir $output_name]"
    close_project
}
puts "PASS: servo, SRAM and DAC bitstreams rebuilt."
