#!/usr/bin/expect -f

set script_name [ file tail [ file normalize [ info script ] ] ]
if {$argc != 2} {
    puts "Usage: expect $script_name <regexp to use for stop pattern> <output file>"
    exit 1
}

try {
    set tty_dev /dev/host/[exec ls -l /dev/host/ttyFLASH | grep -o "/dev/tty.*" | cut -d/ -f3]
    set status 0
} trap CHILDSTATUS {results options} {
    puts "*** Error: no flashable device found ***"
    exit 1
}

set project_path [ file dirname [ file dirname [ file normalize [ info script ] ] ] ]

set stop_pattern [lindex $argv 0]
set output_file [lindex $argv 1]

set fd [open $output_file w]
fconfigure $fd -buffersize 4000
set timeout 10

spawn -noecho microcom -s 115200 $tty_dev

expect {
    -re "$stop_pattern" {
        puts $fd $expect_out(buffer)
    }
    full_buffer {
        puts -nonewline $fd $expect_out(buffer)
        exp_continue
    }
    timeout {
        puts "\nSerial monitor timed out after $timeout secs"
    }
}

send "\0x18a"