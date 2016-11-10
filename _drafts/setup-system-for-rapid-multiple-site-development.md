---
layout: post
title: "Setup System for Rapid Multiple Site Development"
date: 2016-11-02 23:55:00
tags: apache dns bind
description: Guide to setup your System for Rapid Multiple Site Development
---

Setup system for rapid multiple site development

Table of contents / notes
1. configuring local dns
    a. installing & seting up dns
    b. forcing usage of local dns
2. seting up dynamic vhost
    a. install apache if not already
        i. sudo apt-get install lamp-server^
        #mysql and php are not neccessary for this guide but I am 
    b. install proper mods
        i. a2enmod vhost_alias
    c. virtual host file
        i. the file
        ii. a2ensites 900-dev.conf
3. setting default file/directory permissions
    a. setting up dev folder
        i. sudo mkdir /var/www/dev
        ii. sudo setfacl -m d:u:www-data:rwx,d:o::---,d:m::rwx /var/www/dev
4. Adding sites
    a. adding new sites
        i. sudo mkidr -p /var/www/dev/site1/public      #makes folder and public directory for site1.dev
        ii sudo chown -R $USER:$USER /var/www/dev/site1 #change $USER to username that will use edit this directory
    b. transfering in an existing site
        i. sudo mv /current/site/directory /var/www/dev/siteName
        #Note owner and group settings should be carried over if not just chown -R
        ii. sudo setfacl -dR -m u:www-data:rwx,o::---,m::rwx /var/www/dev/siteName #set the default acl values 
        iii. sudo setfacl -R -m u:www-data:rwx,o::---,m::rwx /var/www/dev/siteName #set all the acl values
        iv. if the site did't use a public directory then mv the the files into a public directory
5. The code, the whole code, and nothing but the code