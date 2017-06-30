#!/bin/bash
shopt -s xpg_echo
if [ "$(id -u)" != "0" ]; then
	   echo "This script must be run as root" 
	      exit 1
else
#To create virtual hosts
#Domain name and virtual host name
echo "Enter the domain name"
read name
if [ "$name" == "0" ]; then 
	    echo "You need to supply at least one argument!" 
	        exit 1
	fi
echo "Enter the email"
read email
       regex="^[a-z0-9!#\$%&'*+/=?^_\`{|}~-]+(\.[a-z0-9!#$%&'*+/=?^_\`{|}~-]+)*@([a-z0-9]([a-z0-9-]*[a-z0-9])?\.)+[a-z0-9]([a-z0-9-]*[a-z0-9])?\$"
       if [[ $email =~ $regex ]] ; then
	           echo "Valid Email Address"
	   else
		       echo "Invalid email address, try again"
		       exit 2
	       fi
dir_path="/var/www/$name/public_html"
# Directory structure for virtual hosts
if [ -e /var/www/$name ]; then 
	echo "Domain name already Exist"
	exit 3
fi
mkdir -p $dir_path

# granting permission
chown -R $USER:$USER $dir_path
chmod -R 755 /var/www

# after this step, create a demo page using
touch $dir_path/index.html
echo "<html>
      <head>
      <title> Welcome to my page </title>
      </head>
      <body>
      <h1> Sucess! You're welcome here </h1>
      </body>
      </html>" > $dir_path/index.html
# creating virtual host file
apac_path="/etc/apache2/sites-available"
touch $apac_path/$name.conf
siteAvailabledomain="$apac_path/$name.conf"
echo "
<VirtualHost *:80>
    ServerAdmin $email
    DocumentRoot /var/www/$name/public_html
    ServerName $name
    ServerAlias www.$name.com
</VirtualHost>" >  $siteAvailabledomain
echo "\nVirtual host created"

fi
