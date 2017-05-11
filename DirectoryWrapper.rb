require 'open-uri'
require 'nokogiri'

class DirectoryWrapper
	def self.get_links_from_directory(url)
		dir = Nokogiri::HTML(open(url))
		links = dir.xpath('//th/a') + dir.xpath('//td/a')
		dir_links = links.select { |link| !DirectoryWrapper.has_extension?(link["href"]) }
		file_links = links.select { |link| DirectoryWrapper.has_extension?(link["href"]) }
		return [dir_links, file_links]
	end

	def self.has_extension?(url)
		return url.match(/(.)([a-zA-Z0-9]+)$/)
	end
end