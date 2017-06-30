#!/bin/bash
#make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
	   echo "This script must be run as root" 
	      exit 1
      else 
	      echo "Enter the  user name"
	      read user_name
	      if id -u $user_name; then
		      echo "ALready exists"
	      else
		     useradd $user_name
		     echo "Succesful"
	     fi
     fi
