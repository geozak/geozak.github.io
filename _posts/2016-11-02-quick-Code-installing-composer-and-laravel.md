---
layout: post
title: "Quick Code: Installing Composer and Laravel"
date: 2016-11-02 23:55:00
category: quick-code
tags: php composer laravel
description: Code to get composer and laravel up and running
---

{{ page.description }}

## Install php and web server
```
sudo apt-get install lamp-server^
```

## Install Composer
```
#!/bin/sh

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
```

## Make composer globally accessible
```
sudo mv composer.phar /usr/local/bin/
```

## Install laravel installer
```
sudo apt-get install php7.0-zip php7.0-mbstring php7.0-xml #needed for laravel installer
sudo apt-get install php7.0-sqlite3                        #optional but useful in laravel
composer global require "laravel/installer"                #note this global means user
```

## Make laravel installer accessible (add composer vendor bin to PATH)
```
echo "" >> ~/.bashrc
echo "\$HOME/.config/composer/vendor/bin:\$PATH" >> ~/.bashrc
```

## To make a new project
```
laravel new             #makes new project in the current directory
laravel new projectName #makes new project in a new directory 'projectName'
```

## Sources
[How to install Composer programmatically?](https://getcomposer.org/doc/faqs/how-to-install-composer-programmatically.md)