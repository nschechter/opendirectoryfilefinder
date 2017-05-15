require 'byebug'
require_relative './Directory'
require_relative './DirectoryWrapper'

class DirectoryScraper
	def self.start_scraping(url, force)
		if Directory.get_directory_from_url(url).nil?
			directory = Directory.new(url: url, root_url: url, type: 'root')
			directory.set_links
			puts directory
			DirectoryScraper.scrape_rec(url)
		else
			puts "Already scraped directories @ #{url}"
		end
	end

	def self.scrape_rec(root_url)
		dir_list = Directory.get_unscraped_directories_from_root_url(root_url)
		if dir_list.length > 0
			unscraped_dir = dir_list.first
			unscraped_dir.set_links
			puts unscraped_dir
			DirectoryScraper.scrape_rec(root_url)
		else
			puts "done"
		end
	end
end