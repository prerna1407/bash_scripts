#!/bin/bash
if [ $(id -u) -eq 0 ];
then
	trydomain()
	{
	echo "Enter the domain name"
	read name
	echo $name | grep ^[a-zA-Z0-9][a-zA-Z0-9\-]*.*'[com|edu|in|com|\.in|org]$' >> /dev/null
	if [ $? -eq 0 ];
	then
		if [ -e /var/www/$name  ]
		then
				clear
				echo "Domain name already exists"
				trydomain		
			fi
		else
				clear
				echo "Can't match the pattern"
				trydomain
	fi
	}
	trydomain
    echo "Enter the email"
    read email
    regex="^[a-z0-9!#\$%&'*+/=?^_\`{|}~-]+(\.[a-z0-9!#$%&'*+/=?^_\`{|}~-]+)*@([a-z0-9]([a-z0-9-]*[a-z0-9])?\.)+[a-z0-9]([a-z0-9-]*[a-z0-9])?\$"
    if [[ $email =~ $regex ]] ; then
	echo "Valid Email Address"
    else
	echo "Invalid email address, try again"
	exit 2
	fi
    
# Directory structure for virtual hosts
    dir_path="/var/www/$name/public_html"
    mkdir -p $dir_path

# granting permission
    chown -R $USER:$USER $dir_path
    chmod -R 755 /var/www

 # after this step, create a demo page using
    touch $dir_path/index.html
    echo "
    <html>
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
    echo "####################"
    echo "Virtual host created"
else 
	echo "User must be run as root!!"
fi
