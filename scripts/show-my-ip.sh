#!/bin/bash
# Display your public IP address for tinyproxy Allow configuration

echo "Your public IP address:"
curl -s ifconfig.me || curl -s icanhazip.com || curl -s ipinfo.io/ip
echo
