set root [file normalize [file dirname [info script]]]
set allowed {servo sram dac}
set labs $allowed
if {$argc > 0} {
    set labs $argv
    foreach name $labs {
        if {[lsearch -exact $allowed $name] < 0} {
            error "Unknown FPGA lab: $name (choose servo, sram, or dac)"
        }
    }
}

foreach name $labs {
    set xpr [file join $root $name vivado "stm32_2_${name}.xpr"]
    set xsim [file join $root $name vivado "stm32_2_${name}.sim" sim_1 behav xsim]
    set output [file join $root $name sim]

    open_project $xpr
    set simulation_error [catch {
        launch_simulation -simset sim_1 -mode behavioral
    } reason]
    if {!$simulation_error} {
        close_sim
    }
    close_project

    if {$simulation_error} {
        if {$name ne "dac" || ![string match *simulate.log* $reason]} {
            error $reason
        }
        # An open Vivado GUI can keep the DAC XSim log locked. In that case,
        # run the same checked testbench with Icarus and save its real output.
        set iverilog {C:/msys64/ucrt64/bin/iverilog.exe}
        set vvp {C:/msys64/ucrt64/bin/vvp.exe}
        set old_dir [pwd]
        cd $output
        exec $iverilog -g2012 -s tb -o sim.out [file join $root dac rtl dac.v] tb.sv
        set transcript [exec $vvp sim.out 2>@1]
        cd $old_dir
        if {![regexp -nocase -- {PASS DAC:} $transcript]} {
            error "DAC simulation did not report PASS: $transcript"
        }
        set output_log [file join $output simulation.log]
        set handle [open $output_log w]
        puts $handle $transcript
        close $handle
        puts "PASS dac (Icarus fallback): [file normalize $output_log]"
        continue
    }

    set source_log [file join $xsim simulate.log]
    if {![file exists $source_log]} {
        error "Missing Vivado simulation log: $source_log"
    }
    set handle [open $source_log r]
    set transcript [read $handle]
    close $handle
    if {![regexp -nocase -- "PASS $name:" $transcript]} {
        error "Simulation did not report PASS for $name; inspect $source_log"
    }

    file mkdir $output
    set output_log [file join $output simulation.log]
    file copy -force $source_log $output_log
    set source_wave [file join $xsim wave.vcd]
    if {[file exists $source_wave]} {
        file copy -force $source_wave [file join $output wave.vcd]
    }
    puts "PASS $name: [file normalize $output_log]"
}

puts "PASS: requested FPGA behavioral simulations completed."
