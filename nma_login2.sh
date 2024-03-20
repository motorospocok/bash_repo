#!/bin/bash

# Check if destination IP argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <destination_ip>"
    exit 1
fi

# Server details
username="nmatest"
server_ip="10.244.83.90"

# SSH into the server
ssh -t "$username@$server_ip" << EOF
    # Ping the destination IP address
    ping -c 4 "$1"
EOF
