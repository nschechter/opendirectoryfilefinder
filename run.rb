require_relative './SmartDirScraper'
require_relative './DirCollector'
require_relative './DirectoryScraper'

def run
	sites = []

	#Load in all directories
	File.open("./sites.txt", "r") do |f|
  	f.each_line do |line|
  		if (line.include?("\n"))
    		sites.push(line.slice(0..-2))
    	else
    		sites.push(line)
    	end
  	end
	end

	puts "What do you want to do?"
	puts "1) - Update scraper list"
	puts "2) - Search for an item"
	puts "3) - Download loaded items"
	# input = gets.chomp
	input = 3
	case input
	when 1
		puts "Collecting directories to sites.txt"
		# dircollector = DirCollector.new("Videos")
		# dircollector.start_scraper()
	when 2
		puts "Name of item?"
		name = gets.chomp
		scraper = SmartDirScraper.new(sites[0], name)
		scraper.start_scraping()
	when 3
		puts "Downloading"
		DirectoryScraper.scrape_directory('http://dl2.my98music.com/Data/')
	else
		puts "Couldn't recognize #{input}"
	end
end

def setup

end

run()