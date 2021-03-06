#############################################################
# INTRO
#############################################################

# Use this for batch creating custom screenshots

# We're using phantomJS and Ghastly now rather than Watir Webdriver as it lets us take full page screenshots. However phantomJS doesn't support Flexbox
# yet so need to wait til its updated


#############################################################
# GENERAL SETUP
#############################################################

# Load the webdriver
require 'gastly'

# Define the divider
div = "\n----------------------------------------\n"

# Grab data
require_relative 'data.rb'


#############################################################
# SET UP HELP
#############################################################

if ARGV[0] == "help"
	abort("#{div}Arguments Breakdown:#{div}ruby customScreenshots.rb [Proxy] [URLS] [Responsive]\n\n[Proxy] = Enter your proxy IP address here\n\n[URLS] Enter your array key from customData.rb\n\n[Responsive] Take mobile and tablet screens. Enter 'true' or 'false' \n\n")
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
puts "#{div}"


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

	#Open each resolution and take a screenshot
	if responsive == "true"
		$sizes.each do |resolution, pixel_value|		
			screenshot = Gastly.screenshot(url)
			screenshot.browser_width = pixel_value[:width]
			image = screenshot.capture
			image.save("#{data}_#{page}_#{resolution}.png")
			puts "Taken #{page} #{resolution} screenshot"
		end
	else
		screenshot = Gastly.screenshot(url)
		screenshot.browser_width = 1920
		screenshot.browser_height = 1080
		screenshot.phantomjs_options = '--ignore-ssl-errors=true'
		image = screenshot.capture
		image.save("#{data}_#{page}.png")
		puts "Taken #{page} screenshot"
	end

end


#############################################################
# CLEAN UP
#############################################################

puts "#{div}ALL COMPLETED!#{div}"