#!/usr/bin/expect -f

set timeout -1
set cmd [lindex $argv 0]
set licenses [lindex $argv 1]

spawn {*}$cmd
expect {
    "Accept?" { exp_send "y\r" ; exp_continue }
    eof
}