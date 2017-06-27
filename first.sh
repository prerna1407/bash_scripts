#!/bin/bash

# insert/update hosts entry

echo "Enter the ip address"
read ip_address
echo "Enter the hostname"
read host_name
host_entry="${ip_address} ${host_name}"

    echo "Adding new hosts entry."
    if  echo "$host_entry" | tee -a /etc/hosts > /dev/null
    then
    echo "Succesfully Done"
    else
    echo "make sure you run this as root user" 
    fi
