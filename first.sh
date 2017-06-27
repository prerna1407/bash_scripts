#!/bin/bash

# insert/update hosts entry
echo "Enter the ip address"
read ip_address
echo "Enter the hostname"
read host_name
host_entry="${ip_address} ${host_name}"

echo "Please enter your password if requested."


    echo "Adding new hosts entry."
    echo "$host_entry" | sudo tee -a /etc/hosts > /dev/null

