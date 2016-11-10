#!/bin/sh

rm -rf tag/
jekyll build
cp -r _site/tag ./
git reset HEAD tag/*
git add -f tag/
git update-index --assume-unchanged tag/*
rm -rf tag/
rm -r _site/
