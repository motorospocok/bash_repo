#!/usr/bin/expect -f

## This expect script demonstrates the login and ping destination
##The ping target and number of pings fetched from the command line arguments 
## e.g ./nmalogin 8.8.8.8 3 - ping 3 times ipaddress 8.8.8.8


set destination [lindex $argv 0];
set number [lindex $argv 1];
spawn ssh nmalogin@1.2.3.4
expect "*?assword: *"
send -- "password\r"
expect "*?LINKPI1:~$ *"
spawn ping $destination -c $number
expect "*?LINKPI1:~$ *"
