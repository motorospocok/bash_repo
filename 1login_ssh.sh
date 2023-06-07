#!/usr/bin/expect -f

# Check if argument was passed
if {$argc != 1} {
  puts "Usage: $argv0 <hostname>"
  exit 1
}

# Read login information from data.txt
set file [open "/home/ethtoja/sitefiles/ssh_data.txt" r]
while {[gets $file line] != -1} {
  set login_info [split $line ";"]
  set hostname [lindex $login_info 0]
  set hostip [lindex $login_info 1]
  set user [lindex $login_info 2]
  set password [lindex $login_info 3]

  # Check if hostname matches argument
  if {$hostname eq $argv} {
    # Start SSH session and authenticate using expect
    spawn ssh $user@$hostip
    expect {
      "*assword:" {
        send "$password\r"
        exp_continue
      }
      "yes/no" {
        send "yes\r"
        exp_continue
      }
      "Last login:" {
        interact
      }
      "*:~# " {
        interact
      }
      timeout {
        puts "Error: Connection timed out"
        exit 1
      }
      eof {
        puts "Error: Connection closed by remote host"
        exit 1
      }
    }
    exit 0
  }
}
close $file

# Hostname not found in data.txt
puts "Error: Hostname '$argv' not found in data.txt"
exit 1

