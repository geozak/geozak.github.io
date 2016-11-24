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

Note: This guide will be setting up to handle "*.dev" domains. If you want to use a different domain change all instances of "dev" to the domain you choose.

## Configuring Local DNS

The first step in this process is to dynamically direct development domains to your system.
This will setup direct every domain with the Top-level domain (TLD) 'dev' to the localhost (127.0.0.1). The TLD 'dev' is not an official TLD so there is no worry conflicting with existing domain.

### Installing DNS server

This guide is for linux, more specifically debian based distros, but if you are working on windows checkout [Acrylic DNS Proxy](http://mayakron.altervista.org/wikibase/show.php?id=AcrylicHome). I have not yet used it myself but it has been recommended to me and is still maintained including versions for Windows 10.

Generally when creating domains for development, temporary or not, you have to edit the the /etc/hosts file for each domain. Instead we are going to setup a DNS sever using Bind 9 that we config once and thats it.

```
sudo apt-get install bind9
//sudo apt-get install dnsutils bind9-doc
```

### Configuring DNS server

Now we need to setup Bind to load DNS zone file. We are setting up a zone to catch all request for "*.dev"; this is indicates by naming the zone "dev".
```
sudo nano /etc/bind/named.conf.local
```
Append the following to /etc/bind/named.conf.local
```
zone "dev" {
    type master;
    file "/etc/bind/db.dev"
};
```

### Setting up zone file

We need to configure the zone file so that the DNS server knows what ip address to return for the domain and subdomains. Because this is for local development we can just copy and modify the localhost zone file. Copying the file will setup resolving the 'dev' domain and the following modification will resolve all the subdomains.
```
sudo cp /etc/bind/db.local /etc/bind/db.dev
sudo nano /etc/bind/db.dev
```
Append the following to /etc/bind/db.dev
```
*       IN      CNAME   @
```
Optional but recommended is to edit the file description on the second line to reflect the domain you are using.

### Starting the Server

With this settup the server will startup whenever the system boots up however you may want to start it now for the rest this guide.
```
sudo /etc/init.d/bind9 start
```

### Using the DNS server

Now the DNS server is setup, configured, and running but our system is not using it to resolve domain addresses.

Most guides for changing the DNS servers your system use instruct you to edit the `/etc/resolv.conf` file. While this is the file linux uses to determine what DNS servers, many desktop systems use `resolvconf` to generate the file which overwrites this it frequently especially when connecting to WiFi networks. So in order to make `resolvconf` include our changes we need to edit one of the files in `/etc/resolvconf/resolv.conf.d/`; I prefer to use the `head` file.



To use your local DNS server we need to add the localhost (127.0.0.1) nameserver to our resolvconf file. Optionally I like to add the google DNS servers (8.8.8.8 and 8.8.4.4) here as well so they take higher priority than teh nameservers provided by the WiFi DHCP server.

```
sudo nano /etc/resolvconf/resolv.conf.d/head
# or sudo nano /etc/resolv.conf
```
Make the file look like:
```
nameserver 127.0.0.1
nameserver 8.8.8.8
nameserver 8.8.4.4
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