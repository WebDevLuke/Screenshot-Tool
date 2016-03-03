# Introduction
The offer screenshot tool allows you to automate the screenshot taking process for signoff during the offer creation process.

It supports the following types of offers:
- Standard through the line offers
- Affiliate exclusive offers
- Existing customer / campaign offers

For each offer type it cycles through the relevant pages required for signoff and takes screenshots at desktop, tablet and mobile resolutions and then spits out the JIRA template code to allow you to create a neat little table to add to your Offer JIRA Task comment.

# Installation
This tools uses Ruby and Watir Webdriver. To set this up please follow the instructions below:

### Install Ruby
Before anything you need to make sure you have Ruby installed. Follow the "Installing Homebrew" and "Installing Ruby" sections of https://gorails.com/setup/osx/10.11-el-capitan

###Install Bundler
Bundler is a dependencies manager for Ruby. Essentially a Ruby equivalent of NPM. This will allow us to automatically grab all the different dependancies we will need to make the screenshot tool work correctly.

Once you have installed ruby, run gem install bundler

### Install the tool itself
The below may need to be ran as sudo (depending on your setup)
- run bundle install

# Usage
- Ensure your PDE is on the correct date (where the offer is active)
- cd into webDevtools/offerScreenshots/ if you haven't already
- Run ruby offerScreenshots.rb [Proxy] [PromoCode] [Product Type] [Offer Type] [Area]
	[Proxy] = Enter your proxy/PDE IP address here
	[PromoCode] Enter your promo code here (eg: 1516octoffer1)
	[Product Type] Enter the type of product here. Choose from 'unlimited' or 'unlimited-fibre'
	[Offer Type] Enter the type of offer. Choose from 'standard' 'affiliate' or 'existing-customer'
	[Area] Select either Res or Biz
- This will then open Firefox and cycle through each relevant page and take a screenshot; saving them within the screenshots directory.