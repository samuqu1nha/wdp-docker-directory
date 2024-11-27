#!/bin/sh

# --------------------------------------------------------------------------------
# Date: 27 Nov 2024
# Name: wdpInstall.sh
# Made by: Samuel Nogueira
# Description: Wordpress installation on Docker, using Nginx and MySQL.
# --------------------------------------------------------------------------------


# Functions

# Installs Docker
addDocker() {
    echo
    curl -fsSL https://get.docker.com | bash
}

# Starts Docker
startDocker() {
    echo
    systemctl enable docker
    systemctl start docker
}

# Create user information
login() {
    echo
    echo "Set your username:"
    read user
    echo 
    echo "Your root password and user password will be randomly generated."
    rootpass=$(openssl rand -base64 12)
    userpass=$(openssl rand -base64 12)
}

# Creates docker-compose.yml and wpblog.conf
setup() {

    
    cd ~
    cd ~/wdp-docker-directory/

    echo -e "
    Root password: $rootpass
    User password: $userpass
    " > pswd.txt

    mkdir nginx-conf
    cd nginx-conf/

    # wpblog.conf
    echo '
server {
    listen 80;

    server_name _;

    index index.php index.html index.htm;

    root /var/www/html;

    location ~ /.well-known/acme-challenge {
        allow all;
        root /var/www/html;
    }

    location / {
        try_files $uri $uri/ /index.php$is_args$args;
    }

    location ~ \.php$ {
        try_files $uri =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass wordpress:9000;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param PATH_INFO $fastcgi_path_info;
    }

    location ~ /\.ht {
        deny all;
    }

    location = /favicon.ico {
        log_not_found off; access_log off;
    }

    location = /robots.txt {
        log_not_found off; access_log off; allow all;
    }

    location ~* \.(css|gif|ico|jpeg|jpg|js|png)$ {
        expires max;
        log_not_found off;
    }
}
' > wpblog.conf

    cd ~
    cd ~/wdp-docker-directory/

    # docker-compose.yml
    echo "
services:
  db:
    image: mysql:8.0
    container_name: db
    restart: unless-stopped
    environment:
      MYSQL_DATABASE: wordpress
      MYSQL_ROOT_PASSWORD: $rootpass
      MYSQL_USER: $user
      MYSQL_PASSWORD: $userpass
    command: '--default-authentication-plugin=mysql_native_password'  
    volumes:
      - db-data:/var/lib/mysql
    ports:
      - 3306:3306

  wordpress:
    depends_on:
      - db
    image: wordpress:6.7.1-php8.1-fpm-alpine
    container_name: wordpress
    restart: unless-stopped
    environment:
      WORDPRESS_DB_HOST: db:3306
      WORDPRESS_DB_USER: $user
      WORDPRESS_DB_PASSWORD: $userpass
      WORDPRESS_DB_NAME: wordpress
    volumes:
      - wordpress:/var/www/html

  webserver:
    depends_on:
      - wordpress
    image: nginx:1.27.3-alpine
    container_name: nginx
    volumes:
      - wordpress:/var/www/html
      - ./nginx-conf:/etc/nginx/conf.d/
    ports:
      - 80:80

volumes:
  db-data:
  wordpress:
" > docker-compose.yml

    
}

# Start Docker Compose
dcUp() {
    echo
    cd ~
    cd ~/wdp-docker-directory/
    docker compose up -d
    echo 
    sleep 2
    echo "Script is done."
    echo
    echo "Your passwords are in the pswd.txt file in wdp-docker-directory/"
}

showIP(){

    IP=$(hostname -I | awk '{print $1}')
    echo 
    echo -e "This is your Virtual Machine's ip: $IP"
    echo
}

# --------------------------------------------------------------------------------
# Code
#

isRoot=$(id -u)
if [ $isRoot -ne 0 ]; then
    echo
    echo "Permission denied: must be root."
    sudo su
    exit 1
else 

cd ~
git clone https://github.com/samuqu1nha/wdp-docker-directory.git

traco="------------------------------------------------------------------------------"

echo
echo "$traco"
echo "This script is meant to be run on a brand new CentOS 9 Virtual Machine"
echo "$traco"
echo 
sleep 3

addDocker
startDocker
login
setup
dcUp
showIP
fi

exit 
cd ~
rm -rf wdp-docker-directory
sudo su
cd ~/wdp-docker-directory

# Made by Samuel Nogueira on 27 Nov 2024
