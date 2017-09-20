if [ $(id -u) -eq 0 ]; then
	nginx=$(which nginx)

	if [ $? -eq 0 ]; then
		echo "Nginx is present"
	else
		sudo apt-get install nginx -y
	fi
	php=$(which php)
	if [ $? -eq 0 ]; then
		echo "Php is present"
	else
		sudo apt-get install php7.0-fpm -y
	fi
	mysql=$(which mysqld)
	if [ $? -eq 0 ]; then
		echo "my sql is present"
	else
		sudo apt-get install mysql-server -y
	fi
	domain()
	{
	echo "Enter the domain name"
    read name
    echo $name | grep ^[a-zA-Z0-9][a-zA-Z0-9\-]*.*'[com|edu|in|com|\.in|org]$' >> /dev/null
	if [ $? -eq 0 ]; then
		if [ -e /var/www/$name ]; then
			clear
			echo "Domain name already exists"
			domain
		fi
	else
	    clear
		echo " can't find the pattern"
		domain
	fi
	}
	domain


	echo "127.0.0.1      $name" >> /etc/hosts
	dir_path= /usr/share/nginx/www/$name
	mkdir -p $dir_path
	sudo chown -R $USER:$USER $dir_path
	sudo chmod -R 755 /var/www

	touch $dir_path/index.html
	echo "
	<html>
	<head>
	<title> Welcome to this page </title>
	</head>
	<body>
	<h1> The sserver blocckk is working </h1>
	</body>
	</html>" > $dir_path/index.html

	echo "
	server
	{
		listen 80 default_server;
		server_name $name;
		access_log /var/log/nginx/$name.access.log;
		error_log /var/log/nginx/$name.error.log;
		root /usr/share/nginx/www/$name/wordpress/;
		index index.php index.html index.htm;

		#use fastcgi for all php files
		location ~ \.php$
		{
			include fastcgi_params;
			fastcgi_intercept_errors on;
			fastcgi_pass 127.0.0.1:9000;
			fastcgi_index index.php;
			fastcgi_param SCRIPT_FILENAME /usr/share/nginx/www/wordpress/$fastcgi_script_name;

		}

		location ~ /\.ht
		{
			deny all;
		}

	}
	" >> /etc/nginx/sites-enabled/$name.conf

	mysqldb()
	{
		echo "Read mysql username for creating a database for wordpress"
		read uname
		mysqladmin -u $uname -p create $name\_db
		if [ $? -eq 0 ]; then
			echo "Database created"
		else
			echo "Wrong username or password"
			mysqldb
		fi
	}
	mysqldb
	wget http://wordpress.org/latest.zip
	if [ $? -eq 0 ]; then
		echo "Wordpress downloaded succesfully"
	else
		echo "Internet connection not suitable, try again!"
	fi

	wh=$(which unzip)
	if [ $wh = /usr/bin/unzip ]; then
		echo " Unzip already installed"
	else
		echo " Unzip will be used to intall wordpress but it isn't available."
		sudo apt-get install unzip
	fi

	unzip latest.zip
else

	echo " non- root user!"
fi
