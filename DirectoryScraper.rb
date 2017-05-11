require 'byebug'
require_relative './Directory'
require_relative './DirectoryWrapper'

class DirectoryScraper
	def self.scrape_directory(url)
		dir_links = DirectoryWrapper.get_directory_links(url)
		dir_links.select { |link| !self.has_extension?(link["href"]) }.each do |link|
			directory = Directory.new(root_url: url, url: url + link["href"], type: link.text)
			directory.set_links()
			puts directory
		end
	end

	def self.has_extension?(url)
		return url.match(/(.)([a-zA-Z0-9]+)$/)
	end
end