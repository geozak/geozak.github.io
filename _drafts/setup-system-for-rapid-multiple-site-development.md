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

For many web developers creating new local sites for development is a hassle of having to manage several scattered files. And not to mention the constantly having to manage file permissions that way your webserver can view and operate on your files.

This guide will help you setup your system once so that the only thing you'll need to to create a site is create a directory for the site and your ready to go.

Important: Keep in mind this guide intended for local development. For staging and production use, use critical thinking on how to properly apply concepts from this guide.

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

Most guides for changing the DNS servers your system uses instruct you to edit the `/etc/resolv.conf` file. While this is the file linux uses to determine what DNS servers, many desktop systems use `resolvconf` to generate the file which overwrites this it frequently especially when connecting to WiFi networks. So in order to make `resolvconf` include our changes we need to edit one of the files in `/etc/resolvconf/resolv.conf.d/`; I prefer to use the `head` file.

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

To make the our changes take effect immediately use:
```
sudo resolvconf -u
```

## Setting up Dynamic VHOSTs

We now have all domains that end in '.dev' being redirected to our localhost but we still have the problem that normally we have to create and enable a VirtualHost for each domain we want to use. Luckily apache provides functionality within the VirtualHost configuration that allows us catch and dynamically set the DocumentRoot for all the domains that end in '.dev'.

### The Virtual Host Configuration

Here is the virtual configuration file that accomplishes:
```
sudo nano /etc/apache2/sites-available/900-dev.conf
```
```
<VirtualHost *:80>
    ServerAlias *.dev
    VirtualDocumentRoot "/var/www/dev/%-2+/public"
    <Directory "/var/www/dev/*/public">
        AllowOverride All
        Options Indexes FollowSymLinks MultiViews
    </Directory>
</VirtualHost>
```

### Line by line analysis

`ServerAlias *.dev`: This defines that this virtual host will handle all requests that end in '.dev'.

`VirtualDocumentRoot "/var/www/dev/%-2+/public"`: This is the special way we define the document root for our dynamics domains. The %-2+ will get the whole domain except the TLD '.dev'.

`<Directory "/var/www/dev/*/public">`: This is to make general settings for the sites. We point to the public directory as many frameworks use this style.

`AllowOverride All`: This allows the use of URL rewriting that many frameworks require.

`Options Indexes FollowSymLinks MultiViews`: These are just various 'Options' that may be usefull for general site development.

### Activating the Virtual Host

Now to activate it:
```
sudo a2ensite 900-dev.conf
sudo a2enmod vhost_alias rewrite
sudo service apache2 restart
```
Note: `a2enmod rewrite` is not required for this process but is required by many frameworks. 

If you specific needs for a site that it needs its own virtual host file configuration. Make a virtual host configuration like normal but make the numbers in the file lower for that it is prioritized over our general dynamic one.

## Setting Default File/Directory Permissions

For basic sites everything we've done is enough, but some frameworks and site designs require the site being able to modify or create files within the site's directories. This can be frustrating to have to keep track of and may require toggling file permissions back and forth while working. Instead we can take advantage of the ACL controls in linux. With ACL options we can setup addition users to be associated with file(s) and we can setup default permissions that will be inherited by files and directories created within the directory.

We are going to setup the '/var/www/dev' directory to allow the web and application server to control files and directories within as if it owned the file.

```
sudo mkdir /var/www/dev
sudo setfacl -m d:u:www-data:rwx,d:o::---,d:m::rwx /var/www/dev
```
If you want to expand on the ACL permissions I suggest reading [this guide.](http://www.computerhope.com/unix/usetfacl.htm)

## Adding sites (New normal usage)

Now whenever you want to quickly create a new website all you need to if make a folder for the site.
```
sudo mkdir -p /var/www/dev/SITE-NAME/public
sudo chown -R $USER:$USER /var/www/dev/SITE-NAME
nano /var/www/dev/SITE-NAME/public/index.html
```

### Transitioning sites into new setup

To transition old or existing sites into the setup we need to move the files and copy down the ACL settings:
```
sudo mkdir /var/www/dev/SITE-NAME # important for ACL permisions
sudo mv /old/site/directory/{.,}* /var/www/dev/SITE-NAME # note a warning will appear for '.' and '..'
rmdir /old/site/directory
sudo chown $USER:$USER -R /var/www/dev/SITE-NAME
getfacl /var/www/dev/SITE-NAME | setfacl --set-file=- -R /var/www/dev/SITE-NAME
```

## The code, the whole code, and nothing but the code

### DNS Server
```
sudo apt-get install bind9
sudo cp /etc/bind/db.local /etc/bind/db.dev
sudo sed -i '$ a\\nzone "dev" {\n    type master;\n    file "/etc/bind/db.dev"\n};' /etc/bind/named.conf.local
sudo sed -i '$ a\*       IN      CNAME   @' /etc/bind/db.dev
sudo sed -i '$ a\nameserver 127.0.0.1\nnameserver 8.8.8.8\nnameserver 8.8.4.4' /etc/resolvconf/resolv.conf.d/head
sudo /etc/init.d/bind9 start
sudo resolvconf -u
```

### Dynamic VHOST
```
sudo touch /etc/apache2/sites-available/900-dev.conf
sudo sed -i '$ a\<VirtualHost *:80>\n    ServerAlias *.dev\n    UseCanonicalName Off\n    VirtualDocumentRoot "/var/www/dev/%-2+/public"\n    <Directory "/var/www/dev/*/public">\n        AllowOverride All\n        Options Indexes FollowSymLinks MultiViews\n    </Directory>\n</VirtualHost>' /etc/apache2/sites-available/900-dev.conf
sudo a2ensite 900-dev.conf
sudo a2enmod vhost_alias rewrite
sudo service apache2 restart
```

### Set ACL
```
sudo mkdir /var/www/dev
sudo setfacl -m d:u:www-data:rwx,d:o::---,d:m::rwx /var/www/dev
```

### New Usage
#### Create new site
```
sudo mkdir -p /var/www/dev/SITE-NAME/public
sudo chown -R $USER:$USER /var/www/dev/SITE-NAME
```
#### Transfer a site
```
sudo mkdir /var/www/dev/SITE-NAME
sudo mv /old/site/directory/{.,}* /var/www/dev/SITE-NAME
rmdir /old/site/directory
sudo chown $USER:$USER -R /var/www/dev/SITE-NAME
getfacl /var/www/dev/SITE-NAME | setfacl --set-file=- -R /var/www/dev/SITE-NAME
```

## Sources
[Seven Easy Steps To Setting Up An Interal DNS Server On Ubuntu](http://mixeduperic.com/ubuntu/seven-easy-steps-to-setting-up-an-interal-dns-server-on-ubuntu.html)
[How do I include lines in resolv.conf that won't get lost on reboot?](http://askubuntu.com/a/157192)
[VirutalHost with wildcard VirtualDocumentRoot](http://stackoverflow.com/q/16747013)
[Getting new files to inherit group permissions on Linux](http://unix.stackexchange.com/a/115632)
[Linux and Unix setfacl command](http://www.computerhope.com/unix/usetfacl.htm)


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