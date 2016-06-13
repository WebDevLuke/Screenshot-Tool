#############################################################
# INTRO
#############################################################

# install ruby and then bundler (ruby equivalent of NPM)
# CD into offerScreenshots folder
# type 'bundle install' to install dependencies

# type 'ruby offerScreenshots.rb help' to find out what parameters you need to include
# example: ruby offerScreenshots.rb 10.103.1.51 1516febcash1 unlimited standard res

# Still need to:
# Unlimited fibre extra support

#############################################################
# GENERAL SETUP
#############################################################

# Load the webdriver
require 'watir-webdriver'

# Define the divider
div = "\n----------------------------------------\n"

# Wait for Page Load Function
wait = ->{  
	begin
		Watir::Wait.until(2){} 
	rescue
	end
}

# Grab data
require_relative 'data.rb'

#############################################################
# SET UP HELP
#############################################################

if ARGV[0] == "help"
	abort("#{div}Arguments Breakdown:#{div}ruby offerScreenshots.rb [Proxy] [PromoCode] [Product Type] [Offer Type] [Area]\n\n[Proxy] = Enter your proxy IP address here\n\n[PromoCode] Enter your promo code here (eg: 1516octoffer1)\n\n[Product Type] Enter the type of product here. Choose from 'unlimited' 'unlimited-fibre' and 'unlimited-fibre-extra'\n\n[Offer Type] Enter the type of offer. Choose from 'standard' 'affiliate' 'existing-customer'\n\n[Area] Select either res or biz. Everything is case sensitive.")
end	

#############################################################
# SET UP ARGUMENTS
#############################################################

# Define proxy. If no proxy is given set to nope and don't abort.
proxy = ARGV[0]
 
# Define promo. 
promo = ARGV[1]

# Define product
product = ARGV[2]

# Define offer type
type = ARGV[3]

# Define offer area
area = ARGV[4]

# Abort if the minimum amount of arguments is not reached
if ARGV.length < 5
	abort("You've missed out some arguments")
else
	puts "#{div}Data Entered#{div}"
	puts "Proxy = #{proxy}"
	puts "Promo Code = #{promo}"
	puts "Product = #{product}"
	puts "Offer Type = #{type}\n"
	puts "Area = #{area}\n"
	puts "#{div}Starting...#{div}\n"
end

#############################################################
# CREATE DIRECTORIES
#############################################################

# Lets create screenshot directory if it doesn't exist
unless Dir.exists?("screenshots")
	Dir.mkdir "screenshots"
end

# CD into it 
Dir.chdir "screenshots"

# Create Promo Folder
unless Dir.exists?("#{promo}")
	Dir.mkdir "#{promo}"
end

# CD into Promo Folder
Dir.chdir "#{promo}"

puts "Created directories"

#############################################################
# SET UP PROXY & OPEN BROWSER
#############################################################

# Set Proxy #
profile = Selenium::WebDriver::Firefox::Profile.new
profile.proxy = Selenium::WebDriver::Proxy.new :http => "#{proxy}:80", :ssl => "#{proxy}:80"

# Open Browser with a Proxy #
$browser = Watir::Browser.new :firefox, :profile => profile

#############################################################
# CLICK LEGALS FUNCTION
#############################################################

def legals()
	legals = $browser.h2 :text => "Here's the legal bit"
	legals.exists?
	legals.click
	puts "Opened Legals"
end

#############################################################
# GET RID OF COOKIE BANNER
#############################################################

$browser.goto "https://www.plus.net"
wait.call
cookie = $browser.div(:id => 'cookieBanner').link :text => '×'
if cookie.exists?
	cookie.click
end
puts "Disabled Cookie Banner"

#############################################################
# STANDARD THROUGH THE LINE OFFER
#############################################################

if type == "standard" && area == "res"

	if product == "unlimited"
		goto = $res[:standard][:adsl]
	end

	if product == "unlimited-fibre"
		goto = $res[:standard][:fibre]
	end

	if product == "unlimited-fibre-extra"
		goto = $res[:standard][:fibreExtra]
	end

elsif type == "standard" && area == "biz"

	if product == "unlimited"
		goto = $biz[:standard][:adsl]
	end

	if product == "unlimited-fibre"
		goto = $biz[:standard][:fibre]
	end

end

#############################################################
# EXISTING CUSTOMER CAMPAIGN OFFER
#############################################################

if type == "existing-customer" && area == "res"

	if product == "unlimited"
		goto = $res[:campaign][:adsl]
	end

	if product == "unlimited-fibre"
		goto = $res[:campaign][:fibre]
	end

end

#############################################################
# AFFILIATE OFFER
#############################################################

if type == "affiliate" && area == "res"

	if product == "unlimited"
		goto = $res[:affiliate][:adsl]
	end

	if product == "unlimited-fibre"
		goto = $res[:affiliate][:fibre]
	end

	if product == "unlimited-fibre-extra"
		goto = $res[:affiliate][:fibreExtra]
	end

elsif type == "affiliate" && area == "biz"

	if product == "unlimited"
		goto = $biz[:affiliate][:adsl]
	end

	if product == "unlimited-fibre"
		goto = $biz[:affiliate][:fibre]
	end

end

#############################################################
# TAKE SCREENSHOTS
#############################################################

# Grab the correct list of URLS
goto.each do |page, url|

	# get current page and convert to string
	current = page.to_s
		
	if type == "existing-customer" || type == "affiliate" || current == "deals_lineonly" || current == "deals_eveningsandweekends" || current == "deals_anytime" || current == "deals_anytimeinternational"
		$browser.goto "#{url}#{promo}"
		puts "Opened #{url}#{promo}"
	elsif current == "homepage_slide2"
		$browser.goto "#{url}"
		puts "Opened #{url}"
		if area == "res"
			$browser.element(id: "tk_carousel_tab-2").hover
		elsif area == "biz"
			$browser.element(:css => ".h_beta:nth-child(2)").hover
		end
		puts "Moved to slide 2"
	elsif current == "homepage_slide3"
		$browser.goto "#{url}"
		puts "Opened #{url}"
		if area == "res"
			$browser.element(id: "tk_carousel_tab-3").hover
		elsif area == "biz"
			$browser.element(:css => ".h_beta:nth-child(3)").hover
		end
		puts "Moved to slide 3"
	elsif current == "homepage_slide4"
		$browser.goto "#{url}"
		puts "Opened #{url}"
		if area == "res"
			$browser.element(id: "tk_carousel_tab-4").hover
		elsif area == "biz"
			$browser.element(:css => ".h_beta:nth-child(4)").hover
		end
		puts "Moved to slide 4"
	else
		$browser.goto "#{url}"
		puts "Opened #{url}"
	end

	# Open legals
	legals()

	# Wait til everything is loaded
	wait.call

	#Open each resolution and take a screenshot
	$sizes.each do |resolution, pixel_value|		
		$browser.window.resize_to(pixel_value[:width], pixel_value[:height])
		$browser.screenshot.save "#{promo}_#{page}_#{product}_#{resolution}.png"
		puts "Taken #{resolution} screenshots"
	end
end

#############################################################
# SPIT OUT JIRA TEMPLATE
#############################################################

puts "#{div}Jira Ticket Signoff Template#{div}"
	
puts "{panel:title=(!) Offer sign off - #{promo} | borderColor=#f26d00| titleBGColor=#ffd7b7| borderWidth=3px| bgColor=#FFF| borderStyle=solid}"
puts "h3.#{promo}"
puts "|| Page || Screenshot ||"

if type == "standard"
	puts "| Home page - Slide 1 | [View Preview | ^#{promo}_homepage_slide1_#{product}_desktop.png] |"
	puts "| Home page - Slide 2 | [View Preview | ^#{promo}_homepage_slide2_#{product}_desktop.png] |"
	puts "| Home page - Slide 3 | [View Preview | ^#{promo}_homepage_slide3_#{product}_desktop.png] |"
	puts "| Home page - Slide 4 | [View Preview | ^#{promo}_homepage_slide4_#{product}_desktop.png] |"
	puts "| Packages page (#{product}) | [View Preview | ^#{promo}_packages_#{product}_desktop.png] |"
end

if area == "res" && type == "standard" || area == "res" && type == "affiliate"
	puts "| Deals page (#{product}) - Line Only | [View Preview | ^#{promo}_deals_lineonly_#{product}_desktop.png] |"
	puts "| Deals page (#{product}) - Evenings & Weekends | [View Preview | ^#{promo}_deals_eveningsandweekends_#{product}_desktop.png] |"
	puts "| Deals page (#{product}) - Anytime | [View Preview | ^#{promo}_deals_anytime_#{product}_desktop.png] |"
	puts "| Deals page (#{product}) - Anytime International 300 | [View Preview | ^#{promo}_deals_anytimeinternational_#{product}_desktop.png] |"
elsif area == "biz" && type == "standard" || area == "biz" && type == "affiliate"
	puts "| Deals page (#{product}) - PayG | [View Preview | ^#{promo}_deals_payg_#{product}_desktop.png] |"
	puts "| Deals page (#{product}) - Anytime | [View Preview | ^#{promo}_deals_anytime_#{product}_desktop.png] |"
	puts "| Deals page (#{product}) - Anytime International 500 | [View Preview | ^#{promo}_deals_anytimeinternational500_#{product}_desktop.png] |"
	puts "| Deals page (#{product}) - Anytime International 1000 | [View Preview | ^#{promo}_deals_anytimeinternational1000_#{product}_desktop.png] |"
end

if type == "existing-customer"
	puts "| Existing Customer Campaign Page (#{product}) - Product Upgrade | [View Preview | ^#{promo}_products_#{product}_desktop.png] |"
	puts "| Existing Customer Campaign Page (#{product}) - Product Upgrade | [View Preview | ^#{promo}_products2_#{product}_desktop.png] |"
	puts "| Existing Customer Campaign Page (#{product}) - Product Recontract | [View Preview | ^#{promo}_recontract_#{product}_desktop.png] |"
	puts "| Existing Customer Campaign Page (#{product}) - Product Upgrade | [View Preview | ^#{promo}_recontract2_#{product}_desktop.png] |"
end

puts "(!) You can find a full breakdown of everypage, at every size (mobile, tablet & desktop) on filestore: Departments/Web Development/TAMA/Offer Screenshots/TAMA-NUMBER/"
puts "{panel}"


#############################################################
# CLEAN UP
#############################################################

$browser.close

puts "#{div}ALL COMPLETED!#{div}"

puts "#{div}Next Steps#{div}"
puts "For signoff post desktop screenshots using the Jira template and add all screenshots to fileshare"



