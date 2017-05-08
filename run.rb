require_relative './DirScraper'
require_relative './SmartDirScraper'

def run
	sites = []
	File.open("./sites.txt", "r") do |f|
  	f.each_line do |line|
  		if (line.include?("\n"))
    		sites.push(line.slice(0..-2))
    	else
    		sites.push(line)
    	end
  	end
	end
	puts "Name of item?"
	name = gets.chomp
	scraper = SmartDirScraper.new(sites[0], name)
	scraper.start_scraping()
	# puts "Select Directory to Search: "
	# sites.each.with_index(1) { |site, index| puts "#{index}: #{site}" }
	# input = gets.chomp
	# if input.to_i > 0 && input.to_i <= sites.length
	# 	url = sites[input.to_i-1]
	# 	scraper = DirScraper.new(url, name)
	# 	scraper.scrape()
	# else
	# 	puts "Incorrect input."
	# end

end

def setup

end

run()