require_relative 'DirectoryWrapper'

class Directory

	@@TYPES = ['root', 'movie', 'tv', 'music']
	@@MOVIE_TYPES = ['moving pictures', 'film', 'motion picture', 'features']
	@@TV_TYPES = ['serie', 'tele', 'show', 'serial', 'video', 'anime']
	@@MUSIC_TYPES = ['album', 'song', 'cassette', 'vinyl', 'podcast', 'radio']
	@@SOFTWARE_TYPES = ['game', 'soft', 'exe', 'dmg', 'wares']

	attr_reader :type, :url, :root_url, :dir_links, :file_links, :scraped

	@@directories = []

	def initialize(url:, root_url:, type:)
		@url = url
		@root_url = root_url
		@type = set_type(type.downcase)
		@dir_links = []
		@file_links = []
		@scraped = false
		@children = []

		@@directories << self
	end

	def set_links()
		@dir_links, @file_links = DirectoryWrapper.get_links_from_directory(@url, @root_url)
		@scraped = true
	end

	def set_type(type)
		if !@@TYPES.any? { |t| type.include?(t) }
			if @@MOVIE_TYPES.any? { |t| type.include?(t) }
				return 'movie'
			elsif @@TV_TYPES.any? { |t| type.include?(t) }
				return 'tv'
			elsif @@MUSIC_TYPES.any? { |t| type.include?(t) }
				return 'music'
			elsif @@SOFTWARE_TYPES.any? { |t| type.include?(t) }
				return 'software'
			else
				return type
			end
		else
			return @@TYPES.select { |t| type.include?(t) }.first
		end
	end

	def to_s()
		return "#{@type}: #{@dir_links.length} - #{@file_links.length}"
	end

	def is_empty?
		return @dir_links.length == 0
	end

	def is_root?
		return @url == @root_url
	end

	def self.get_directories()
		return @@directories
	end

	def self.get_unscraped_directories_from_root_url(root_url)
		return @@directories.select { |dir| !dir.scraped && dir.root_url === root_url }
	end

	def self.get_directory_from_url(url)
		return @@directories.find { |dir| dir.url === url }
	end

	def self.get_directories_of_type(type)
		return @@directories.select { |dir| dir.type === type }
	end

	def self.get_file_link_from_directories(file_name, dir_list)
		file_link = nil
		dir_list.each do |dir| 
			dir.file_links.each do |link| 
				if link["href"].downcase.include?(file_name.downcase)
					file_link = link
				end
			end
		end
		return file_link
	end

end