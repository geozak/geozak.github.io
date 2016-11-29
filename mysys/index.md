---
layout: page
---




## Basics

```
sudo apt-get update
sudo apt-get upgrade
sudo apt-get dist-upgrade

sudo apt-get install htop
```



## Web servers
```
sudo apt-get install lamp-server^

```


## Install Composer
```
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
```

## Install laravel
```
sudo apt-get install php7.0-zip php7.0-mbstring php7.0-xml #needed for laravel installer
sudo apt-get install php7.0-sqlite3                        #optional but useful in laravel
composer global require "laravel/installer"                #note this global means user

sed -i '$ a\\nPATH="\$HOME/.config/composer/vendor/bin:\$PATH"' ~/.bashrc
source ~/.bashrc

laravel new randomNameThatShouldNotExist #caches many of the libraries
rm -rf randomNameThatShouldNotExist/
```

## Install Jekyll on Linux
```
sudo apt-get install ruby-dev
sudo gem install jekyll
```