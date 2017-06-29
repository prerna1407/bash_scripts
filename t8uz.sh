#!/bin/bash
#To create virtual hosts
#Domain name and virtual host name
echo "Enter the domain name"
read name
echo "Enter the email"
read email
#I know you can do this. This is 

# Directory structure for virtual hosts
mkdir -p /var/www/$name/public_html

# granting permission
chown -R $USER:$USER /var/www/$name/public_html
chmod -R 755 /var/www

# after this step, create a demo page using
touch /var/www/$name/public_html/index.html
echo "<html>
      <head>
      <title> Welcome to my page </title>
      </head>
      <body>
      <h1> Sucess! You're welcome here </h1>
      </body>
      </html>" > /var/www/$name/public_html/index.html
# creating virtual host file
touch /etc/apache2/sites-available/$name.conf
siteAvailabledomain='/etc/apache2/sites-available/$name.conf'
echo "
<VirtualHost *:80>
    ServerAdmin $email
    DocumentRoot /var/www/$name/public_html
    ServerName $name
    ServerAlias www.$name.com
</VirtualHost>" >  /etc/apache2/sites-available/$name.conf
echo "\n Virtual host created"

#adding ip address and domain to /etc/hosts file
echo "127.0.0.1 $name" | tee -a /etc/hosts > /dev/null

a2ensite $name.conf
systemctl reload apache2

echo "Browse to http://$name"
