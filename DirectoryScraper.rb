require 'byebug'
require_relative './Directory'
require_relative './DirectoryWrapper'

class DirectoryScraper
	def self.scrape_root_directory(url)
		root_directory = Directory.new(parent_url: url, href: url, type: 'root')
		root_directory.set_links()
		puts root_directory
		# root_directory.dir_links.each do |link|
		# 	directory = Directory.new(false, parent_url: url, url: url + link["href"], type: link.text)
		# 	directory.set_links()
		# 	puts directory
		# end
	end

	def self.scrape_inner_directories(parent_url)
		directories = Directory.get_directories().select { |dir| !dir.is_root? }
		directories.each do |dir|
			dir.dir_links.each do |link|
				directory = Directory.new(parent_url: parent_url, href: link["href"], type: link.text)
				directory.set_links()
				puts directory
			end
		end
	end

	def self.scrape_directory_recursively(is_root, href, parent_url, type)
		if is_root
			directory = Directory.new(href: href, parent_url: parent_url, type: 'root')
		else
			directory = Directory.new(href: href, parent_url: parent_url, type: type)
		end

			puts directory.url
			directory.set_links()
			parent_url = parent_url + href
			current_dir = directory.dir_links[1]
			puts directory.dir_links.length

		if directory.is_empty?
			DirectoryScraper.scrape_directory_recursively(false, Directory.get_directory_from_url(parent_url), Directory.get_directory_from_url(parent_url).parent_url, Directory.get_directory_from_url(parent_url).type)
		else
			DirectoryScraper.scrape_directory_recursively(false, current_dir["href"], parent_url, current_dir.text)
		end
	end

	#scrape_dir_recursively('http://dl2.my98music.com/Data/', true)

	def self.scrape_directory(url)
		directory = Directory.new(href: '', parent_url: url, type: 'root')
		directory.set_links()
		puts directory
		current_index = 0

		while (current_index < directory.dir_links.length)
			current_dir = directory.dir_links[current_index]
			DirectoryScraper.index_directory(current_dir["href"], directory.url, current_dir.text)
			current_index += 1
		end
	end

	def self.index_directory(href, parent_url, type)
		directory = Directory.new(href: href, parent_url: parent_url, type: type)
		directory.set_links
		puts directory

		if !directory.is_empty?
			puts "nope"
		end
	end

	def self.scrape_directory2(url, parent_url, type)
		dir = Directory.get_directory_from_url(url + href)
		if dir && !dir.children_scraped?
			puts "children not scraped"
			scrape_directory2(dir.get_unscraped_children().first.url, parent_url, 'recursion')
		elsif dir && dir.children_scraped?
			byebug
			puts "children scraped"
			scrape_directory2('', dir.parent_url, dir.type)
		else
			puts "dir doesn't exist"
			puts "href: #{href} parent_url: #{parent_url}"
			#create it
			directory = Directory.new(href: href, parent_url: parent_url, type: 'recursion')
			directory.set_links
			scrape_directory2(href, parent_url, type)
		end
	end

	def self.scrape_rec(url)

	end
end

# if all the child directories exist, go to parent and see if it's children exist.
# if the all the children do not exist, go into the next unavailable one and scrape.

#if directory has more directories, go in first one
# once there are no more directories, go up back and to the next

#movies
# -lord of the rings
# -zoolander
# -step brothers
#tv
# -mr robot
# -silicon valley
# -shows
# -series
#music
# -v0
# -v8
# -flac