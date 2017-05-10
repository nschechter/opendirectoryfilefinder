require 'open-uri'
require 'nokogiri'

class DirectoryWrapper
	def self.get_directory_links(url)
		dir = Nokogiri::HTML(open(url))
		links = dir.xpath('//th/a') + dir.xpath('//td/a')
		return links
	end
end