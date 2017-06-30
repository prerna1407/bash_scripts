#!/bin/bash
#make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
	   echo "This script must be run as root" 
	      exit 1
      else
#insert the values for ip and host
	      echo "Enter the ip address"
	      read ip_address
	      echo "Enter the hostname"
	      read host_name
	      host_entry="${ip_address} ${host_name}"
	      echo "Adding new hosts entry."
	      echo "$host_entry" | tee -a /etc/hosts > /dev/null
	      echo "Succesfully Done" 
fi
