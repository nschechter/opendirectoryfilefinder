require 'byebug'
require_relative './models/OpenDir'
require_relative './DirectoryWrapper'

class DirectoryScraper
	def self.start_scraping(url)
		dir = OpenDir.get_directory_from_url(url, type)
		if dir.nil?
			dir = OpenDir.create!(url: url, root_url: url, dir_type: type)
			dir.set_links
			if dir # If it has not been deleted
				puts dir
				DirectoryScraper.scrape_rec(url)
			else
				puts "Directory @ #{url} is invalid"
			end
		else
			puts "Already scraped directories @ #{url}"
		end
	end

	def self.scrape_rec(root_url)
		dir_list = OpenDir.get_unscraped_directories_from_root_url(root_url)
		if dir_list.length > 0
			unscraped_dir = dir_list.first
			unscraped_dir.set_links
			puts unscraped_dir
			DirectoryScraper.scrape_rec(root_url)
		else
			puts "done"
		end
	end

	def self.scrape_reddit()
		resp = OpenURIWrapper.get('https://www.reddit.com/r/opendirectories/', 'opendirectories')
		n_resp = Nokogiri::HTML(resp)

		#Grab all the titles of each post on the front page of /r/opendirectories
		#Uses class of 'title may-blank outbound' to differentiate the post links from regular ones
		links = n_resp.xpath("//a[@class='title may-blank outbound']")

		links.each do |link|
			DirectoryScraper.start_scraping(link["href"])
		end
	end
end