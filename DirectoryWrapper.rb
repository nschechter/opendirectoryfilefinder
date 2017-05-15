require 'open-uri'
require 'nokogiri'
require_relative './models/OpenDir'

class DirectoryWrapper
	def self.get_links_from_directory(url, root_url)
		# Retrieve the response and parse it with Nokogiri
		dir = Nokogiri::HTML(open(url))

		# Retrive all the links in as a child of a th or td
		links = dir.xpath('//th/a[not(child::*)]') + dir.xpath('//td/a[not(child::*)]')

		# Filter the parent directory
		links = links.select { |link| !DirectoryWrapper.is_parent?(link.text) }

		# Filter out the links that route to more folders
		dir_links = links.select { |link| !DirectoryWrapper.has_extension?(link["href"]) }

		# Create new unscraped directories out of each of the child folders
		dir_links.each do |link|
			OpenDir.create!(url: url + link["href"], root_url: root_url, dir_type: link.text)
		end

		# Filter ou the links that route to files
		file_links = links.select { |link| DirectoryWrapper.has_extension?(link["href"]) }

		return [dir_links, file_links]
	end

	# Returns if a url has a file extension
	def self.has_extension?(url)
		return url.match(/(.)([a-zA-Z0-9]+)$/)
	end

	# Returns if a url routes to the parent directory
	def self.is_parent?(text)
		return text.match(/(Parent|Directory|\.\.)/)
	end
end