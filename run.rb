require_relative './SmartDirScraper'
require_relative './DirCollector'
require_relative './DirectoryScraper'
require_relative './Directory'

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
	puts "scrape) - Scrape directory"
	puts "type) - Search for directory types"
	puts "download) - Download loaded items"
	input = gets.chomp
	while input != 'exit'
		case input
		when 'download'
			puts "Type? (optional)"
			type = gets.chomp
			dir_list = Directory.get_directories_of_type(type)
			puts "Name?"
			file_name = gets.chomp
			link = Directory.get_file_link_from_directories(file_name, dir_list)
			if link
				puts link.text
			else
				puts "couldn't find"
			end
		when 'type'
			puts "Type?"
			type = gets.chomp
			puts Directory.get_directories_of_type(type)
		when 'scrape'
			puts "Downloading..."
			DirectoryScraper.start_scraping('http://sirftp.com/', false)
		else
			puts "I don't understand."
		end
		if input != 'exit'
			input = gets.chomp
		end
	end
end

run()