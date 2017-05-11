require 'byebug'
require_relative './Directory'
require_relative './DirectoryWrapper'

class DirectoryScraper
	def self.scrape_directory(url)
		root_directory = Directory.new(root_url: url, url: url, type: 'root')
		root_directory.set_links()
		root_directory.dir_links.each do |link|
			directory = Directory.new(root_url: url, url: url + link["href"], type: link.text)
			directory.set_links()
			puts directory
		end
	end
end