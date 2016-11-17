---
layout: post
title: "Setup System for Rapid Multiple Site Development"
date: 2016-11-02 23:55:00
tags: apache dns bind
description: Guide to setup your System for Rapid Multiple Site Development
---

## Sections

1. [Introduction](#introduction)
2. [Configuring Local DNS](#configuring-local-dns)
3. [Setting up Dynamic VHOSTs](#setting-up-dynamics-vhosts)
4. [Setting Default File/Directory Permissions](#setting-default-file-directory-permissions)
5. [Adding sites (New normal usage)](#adding-sites-new-normal-usage)
6. [The code, the whole code, and nothing but the code](#the-code-the-whole-code-and-nothing-but-the-code)
7. [Sources](#sources)


## Introduction

For many web developers creating new local sites for development is hassle of having to manage several scattered files. And not to mention the constantly having to manage file permissions that way your webserver can view and operate on your files.

This guide will help you setup your system once so that the only thing you'll need to to create a site is create a directory for the site and your ready to go.

## Configuring Local DNS

The first step in this process is to dynamically direct development domains to your system.
This will setup direct every domain with the Top-level domain (TLD) 'dev' to the localhost (127.0.0.1). The TLD 'dev' is not an official TLD so there is no worry conflicting with existing domain.

This guide is for linux, more specifically debian based distros, but if you are working on windows checkout [Acrylic DNS Proxy](http://mayakron.altervista.org/wikibase/show.php?id=AcrylicHome). I have not yet used it myself but it has been recommended to me and is still maintained including versions for Windows 10.

Generally when creating domains for development, temporary or not, you have to edit the the /etc/hosts file for each domain. Instead we are going to setup a DNS sever using Bind 9 that we config once and thats it.

```
sudo apt-get install bind9
//sudo apt-get install dnsutils bind9-doc
sudo nano /etc/bind/named.conf.options
```

insert the following snippet in /etc/bind/named.conf.options

```
...

        forwarders {
                8.8.8.8;
                8.8.4.4;
        };

...

```

## Setting up Dynamic VHOSTs



## Setting Default File/Directory Permissions



## Adding sites (New normal usage)



## The code, the whole code, and nothing but the code

## Sources



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
    c.  virtual host file
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