# Introduction
A screenshot automation tool.

# Installation
This tools uses Ruby and Watir Webdriver. To set this up please follow the instructions below:

### Install Ruby
Before anything you need to make sure you have Ruby installed. Follow the "Installing Homebrew" and "Installing Ruby" sections of https://gorails.com/setup/osx/10.11-el-capitan

###Install Bundler
Bundler is a dependencies manager for Ruby. Essentially a Ruby equivalent of NPM. This will allow us to automatically grab all the different dependancies we will need to make the screenshot tool work correctly.

Once you have installed ruby, run `gem install bundler`

### Install the tool itself
The below may need to be ran as sudo (depending on your setup)
- run `bundle install`