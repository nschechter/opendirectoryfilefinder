require 'open-uri'
require 'nokogiri'
require_relative './models/OpenDir'

class DirectoryWrapper
	def self.get_links_from_directory(url, root_url)
		# Retrieve the response and parse it with Nokogiri
		dir = Nokogiri::HTML(open(url))

		# Retrive all the links in as a child of a th or td or li
		links = dir.xpath('//th/a[not(child::*)]') + dir.xpath('//td/a[not(child::*)]') + dir.xpath('//li/a[not(child::*)]')

		# If it's powered by h5ai, return false. Need to add support for it later.
		meta_tags = dir.xpath('//head/meta')
		if meta_tags && meta_tags.any? { |tag| tag['content'] && tag['content'].include?('h5ai') }
			puts "Error - no support for h5ai"
			return nil
		end

		# If we have detected a directory
		if links.length > 0
			# Filter the parent directory
			links = links.select { |link| !DirectoryWrapper.is_parent?(link.text) }

			# Filter out the links that route to more folders
			dir_links = links.select { |link| DirectoryWrapper.has_directory_extension?(link['href']) }

			# Create new unscraped directories out of each of the child folders
			dir_links.each do |link|
				OpenDir.create!(url: url + link['href'], root_url: root_url, dir_type: link.text)
			end

			# Filter ou the links that route to files
			file_links = links.select { |link| DirectoryWrapper.has_file_extension?(link['href']) }

			# Recreate the links to point only to their URL
			file_links = file_links.map { |link| url + link['href'] }

			return [dir_links, file_links]
		else
			return nil
		end 
	end

	# Returns if a url has a file extension
	def self.has_file_extension?(url)
		return url.match(/(\.)([a-zA-Z0-9]){3,4}$/)
	end

	def self.has_directory_extension?(url)
		return url.match(/\/$/)
	end

	# Returns if a url routes to the parent directory
	def self.is_parent?(text)
		return text.match(/(Parent|Directory|\.\.)/)
	end
end