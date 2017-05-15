require 'byebug'
require_relative './models/OpenDir'
require_relative './DirectoryWrapper'

class DirectoryScraper
	def self.start_scraping(url, force)
		if OpenDir.get_directory_from_url(url).nil?
			dir = OpenDir.create!(url: url, root_url: url, dir_type: 'root')
			OpenDir.set_links(dir)
			puts dir
			DirectoryScraper.scrape_rec(url)
		else
			puts "Already scraped directories @ #{url}"
		end
	end

	def self.scrape_rec(root_url)
		dir_list = OpenDir.get_unscraped_directories_from_root_url(root_url)
		if dir_list.length > 0
			unscraped_dir = dir_list.first
			OpenDir.set_links(unscraped_dir)
			puts unscraped_dir
			DirectoryScraper.scrape_rec(root_url)
		else
			puts "done"
		end
	end
end