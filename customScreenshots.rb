#############################################################
# INTRO
#############################################################

# Use this for batch creating custom screenshots


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

# Grab custom data
require_relative 'customData.rb'

#############################################################
# SET UP HELP
#############################################################

if ARGV[0] == "help"
	abort("#{div}Arguments Breakdown:#{div}ruby customScreenshots.rb [Proxy] [URLS]\n\n[Proxy] = Enter your proxy IP address here\n\n[URLS] Enter your array key from customData.rb\n\n[Responsive] Take mobile and tablet screens. Enter 'true' or 'false' \n\n")
end	

#############################################################
# SET UP ARGUMENTS
#############################################################

proxy = ARGV[0]
data = ARGV[1]
responsive = ARGV[2]

# Abort if the minimum amount of arguments is not reached
puts "#{div}Data Entered#{div}"
puts "Proxy = #{proxy}"
puts "Custom URLs = #{data}"
puts "Take Responsive Screens = #{responsive}"

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
unless Dir.exists?("#{data}")
	Dir.mkdir "#{data}"
end

# CD into Promo Folder
Dir.chdir "#{data}"

puts "Created directories"


#############################################################
# SET UP PROXY & OPEN BROWSER
#############################################################

# Set Proxy #
profile = Selenium::WebDriver::Firefox::Profile.new

if proxy != "none"
	profile.proxy = Selenium::WebDriver::Proxy.new :http => "#{proxy}:80", :ssl => "#{proxy}:80"
end

# Open Browser with a Proxy #
$browser = Watir::Browser.new :firefox, :profile => profile

#############################################################
# CLICK LEGALS FUNCTION
#############################################################

def legals()
	legals = $browser.h2 :text => "Here's the legal bit"
	jlplegals = $browser.span :class => 'expander-control'
	if legals.exists?
		puts "Clicked Legals"
		legals.click
	elsif jlplegals.exists?
		puts "Clicked JLP Legals"
		jlplegals.click
	else
		puts "No legals found to click"
	end
end

#############################################################
# GET RID OF COOKIE BANNER
#############################################################

$browser.goto "https://www.plus.net"
wait.call
cookie = $browser.div(:id => 'cookieBanner').link :text => '×'
if cookie.exists?
	cookie.click
	puts "Disabled Cookie Banner"
end

#############################################################
# DEFINE DATA PATHS
#############################################################

goto = $customUrls[:"#{data}"]

#############################################################
# TAKE SCREENSHOTS
#############################################################

# Grab the correct list of URLS
goto.each do |page, url|

	# get current page and convert to string
	current = page.to_s
		
	$browser.goto "#{url}"
	puts "Opened #{url}"

	# Open legals
	legals()

	# Wait til everything is loaded
	wait.call

	#Open each resolution and take a screenshot
	if responsive == true
		$sizes.each do |resolution, pixel_value|		
			$browser.window.resize_to(pixel_value[:width], pixel_value[:height])
			$browser.screenshot.save "#{data}_#{page}_#{resolution}.png"
			puts "Taken #{page} #{resolution} screenshot"
		end
	else
		$browser.window.resize_to(1200, 800)
		$browser.screenshot.save "#{data}_#{page}.png"
		puts "Taken #{page} screenshot"
	end

end

#############################################################
# SPIT OUT JIRA TEMPLATE
#############################################################

puts "#{div}Jira Ticket Signoff Template#{div}"
	
puts "{panel:title=(!) Signoff Screenshots | borderColor=#f26d00| titleBGColor=#ffd7b7| borderWidth=3px| bgColor=#FFF| borderStyle=solid}"
puts "h3.Signoff Screenshots"
puts "|| Page || Screenshot ||"

goto.each do |page, url|
	if responsive == true
		puts "| #{page} | [View Preview | ^#{data}_#{page}_#{resolution}.png] |"
	else
		puts "| #{page} | [View Preview | ^#{data}_#{page}.png] |"
	end
end

puts "{panel}"


#############################################################
# CLEAN UP
#############################################################

$browser.close

puts "#{div}ALL COMPLETED!#{div}"


