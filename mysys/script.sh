#!/bin/sh

sudo apt-get update
sudo apt-get upgrade
sudo apt-get dist-upgrade
sudo apt-get install lamp-server^

sudo apt-get install bind9 php7.0-{zip,mbstring,xml,sqlite3} ruby-dev htop
sudo apt-get install bind9 php7.0-zip php7.0-mbstring php7.0-xml  php7.0-sqlite3 ruby-dev htop

cpp gcc git git-sh gksu gparted 
openjdk-*-{jdk,jre}
sqlite3
sublimetext
vlc

sshserver

ppa:...
grub customizer


# Configure DNS
sudo cp /etc/bind/db.local /etc/bind/db.dev
sudo sed -i '$ a\\nzone "dev" {\n    type master;\n    file "/etc/bind/db.dev"\n};' /etc/bind/named.conf.local
sudo sed -i '$ a\*       IN      CNAME   @' /etc/bind/db.dev
sudo sed -i '$ a\nameserver 127.0.0.1\nnameserver 8.8.8.8\nnameserver 8.8.4.4' /etc/resolvconf/resolv.conf.d/head
sudo /etc/init.d/bind9 start
sudo resolvconf -u


# Configure VHOST
sudo touch /etc/apache2/sites-available/900-dev.conf
sudo sed -i '$ a\<VirtualHost *:80>\n    ServerAlias *.dev\n    UseCanonicalName Off\n    VirtualDocumentRoot "/var/www/dev/%-2+/public"\n    <Directory "/var/www/dev/*/public">\n        AllowOverride All\n        Options Indexes FollowSymLinks MultiViews\n    </Directory>\n</VirtualHost>' /etc/apache2/sites-available/900-dev.conf

sudo a2ensite 900-dev.conf
sudo a2enmod vhost_alias rewrite
sudo service apache2 restart

sudo mkdir /var/www/dev
sudo setfacl -m d:u:www-data:rwx,d:o::---,d:m::rwx /var/www/dev


# Install Composer
EXPECTED_SIGNATURE=$(wget https://composer.github.io/installer.sig -O - -q)
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_SIGNATURE=$(php -r "echo hash_file('SHA384', 'composer-setup.php');")

if [ "$EXPECTED_SIGNATURE" = "$ACTUAL_SIGNATURE" ]
then
    php composer-setup.php --quiet
    RESULT=$?
    rm composer-setup.php
    exit $RESULT
else
    >&2 echo 'ERROR: Invalid installer signature'
    rm composer-setup.php
    exit 1
fi

sudo mv composer.phar /usr/local/bin/


# Install laravel
composer global require "laravel/installer"

sed -i '$ a\\nPATH="\$HOME/.config/composer/vendor/bin:\$PATH"' ~/.bashrc
source ~/.bashrc

laravel new randomNameThatShouldNotExist #caches many of the libraries
rm -rf randomNameThatShouldNotExist/


# Install Jekyll
sudo gem install jekyll