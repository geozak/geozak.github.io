---
layout: post
title: "Setting up Jekyll for GitHub Pages"
date: 2016-11-08 22:05:20
tags: jekyll
description: Guide to setup Jekyll for GitHub Pages and local development
---

## Sections

1. [Introduction](#introduction)
2. [Setting Up GitHub Pages](#setting-up-github-pages)
3. [Installing Jekyll](#installing-jekyll)
    i. Linux
    ii. Windows
    iii. Mac
4. [Including a Theme](#including-a-theme)
5. [Tags](#tags)
6. [Development Tips](#development-tips)
7. [Sources](#sources)

## Introduction

This is a (hopefuly) simple guide to getting setup building a blog.

This guide shows you how to setup [GitHub Pages](https://pages.github.com/) using [Jykell](https://jekyllrb.com) and theme that I [modified](https://github.com/geozak/jekyll-clean-dark).

This guide won't go into detail about how git or github work. It is more of a quick and dirty instructional to get started with Jykell on GitHub Pages.

## Setting Up GitHub Pages

GitHub offers a static webhosting for users (username.github.io/) and each reposity (username.github.io/repositoryname/).

To make a webisite at the root directory create a repository named username.github.io and anything in the master branch will be converted into the website.
To make other repositories into a website create a branch named gh-pages and anything in that branch will be converted into the website.

The default branch for either style can be changed in the repository settings and can even set it so that only files within a 'docs' directory will get converted.

After creating the repository, initialize and link it to a local development repository.

## Installing Jekyll

<div class="panel panel-default">

    <!-- Nav tabs -->
    <ul class="nav nav-tabs" role="tablist">
        <li role="presentation" class="active"><a href="#linux" aria-controls="linux" role="tab" data-toggle="tab">Linux</a></li>
        <li role="presentation"><a href="#windows" aria-controls="windows" role="tab" data-toggle="tab">Windows</a></li>
        <li role="presentation"><a href="#mac" aria-controls="mac" role="tab" data-toggle="tab">Mac</a></li>
    </ul>

    <!-- Tab panes -->
    <div class="tab-content">
        <div role="tabpanel" class="tab-pane active" id="linux">
            <div class="container-fluid" markdown="1">    
### Install Jekyll on Linux
```
sudo apt-get install ruby-dev
sudo gem install jekyll
```

### Install Jekyll on older Linux Distros

(Updated 2016-11-23)<br>
If the version of ruby in your distro's repository is not be new enough to install jekyll, use these commands.

```
sudo apt-get purge ruby
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
\curl -sSL https://get.rvm.io | bash -s stable --ruby
source ~/.rvm/scripts/rvm
gem install bundler
gem install jekyll
```
</div> <!-- This close tag must be left aligned. -->
        </div> <!-- close linux -->
        <div role="tabpanel" class="tab-pane" id="windows">
            <div class="container-fluid" markdown="1">
### Install Jekyll on Windows

1. Install the latest of ruby from [RubyInstaller](http://rubyinstaller.org/downloads/)
    1. Run rubyinstaller-*.exe
    2. Make sure to check the option adding Ruby to you PATH
2. Install the Development Kit for your version of Ruby from [RubyInstaller](http://rubyinstaller.org/downloads/)
    1. Run DevKit-*-sfx.exe
    2. Extract to a unique folder (e.g. C:\Users\geozak\Downloads\DevKit)
    3. Open a Command Prompt and navigate the the folder
    4. Execute `ruby dk.rb init`
    5. Execute `ruby dk.rb install`
    6. Download the rubygems-update gem from [RubyGem](https://rubygems.org/pages/download)
    7. Change directory to the rubygems file
    8. Execute `gem install rubygems-update-*.gem`
    9. Execute `update_rubygems`
    10. Execute `gem install jekyll`
</div> <!-- This close tag must be left aligned. -->
        </div> <!-- close windows -->
        <div role="tabpanel" class="tab-pane" id="mac">
            <div class="container-fluid" markdown="1">
### Install Jekyll on Mac
Open Terminal (Applications->Utilities->Terminal)

```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install ruby
sudo gem install bundler
sudo gem install jekyll
```
</div> <!-- This close tag must be left aligned. -->
        </div> <!-- close mac -->
    </div> <!-- close Tab Panes-->
</div>

## Including a Theme

Including a theme for jekyll is really easy.

1. Find a theme you like ([My Theme](https://github.com/geozak/jekyll-clean-dark))
2. Copy the files into your local repository
3. Delete the example post in the _posts directory
4. Edit the config files (_config.yml)

## Tags

Jekyll has tags but doesn't much native support for them. With tags it is nice to have pages that list all the posts with a certain tag. Many themes accomplish with a [plugin](http://charliepark.org/tags-in-jekyll/) by charliepark.

This plugin works great however GitHub Pages doesn't allow the use of plugins. So every time you add a post or update tags, you'll need to generate the site locally then copy the files generated by the plugin (the tag directory) into the root directory of the project.
Also because of how jekyll prioritizes plugins vs existing files you will need to make sure to remove the tag directory before generating the site locally.

That may be hard to follow because the process is a little convoluted.
Heres a small script to demostrate the process:

```
rm -r tag/
jekyll build
#verify the site output
cp -r _site/tag ./
git add -A
git commit
```

## Development Tips

If you are using [My Theme](https://github.com/geozak/jekyll-clean-dark), I have included some extra files to aid in development.

For development on testing on your local system I have included a file called '_config-local.yml'.
I find this useful so that I am not constantly changing my config file back and forth for commits, especially for the url, baseurl, include and exclude setting.
Use the config file wth one of these commands:

```
jekyll build --config _config-local.yml
jekyll serve --config _config-local.yml
```

For the handling the confusion of dealing with tags and including them in git I created a bash script to handle them. The script increases the benifit of using separate config files.
It generates the the tag files, adds them to the git stageing, and cleans working directory so that the files don't interfer with local development and testing while making git not scream at you for missing the tag.

```
sh prep-tags-for-git.sh
```

If you are using Windows I recommend using Git Bash from [git for windows](https://git-for-windows.github.io/).
This with will enable you to utilize the script I created for handling the tag pages.

## Sources

[Jekyll Installation](http://jekyllrb.com/docs/installation/)
[Run Jekyll on Windows](http://jekyll-windows.juthilo.com/)
[RVM: Ruby Version Manager](https://rvm.io/rvm/install)