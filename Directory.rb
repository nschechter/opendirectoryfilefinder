require_relative 'DirectoryWrapper'

class Directory

	@@TYPES = ['movie', 'tv', 'music']
	@@MOVIE_TYPES = ['moving pictures', 'film', 'motion picture', 'features']
	@@TV_TYPES = ['serie', 'tele', 'show', 'serial', 'video', 'anime']
	@@MUSIC_TYPES = ['album', 'song', 'cassette', 'vinyl', 'podcast', 'radio']
	@@SOFTWARE_TYPES = ['game', 'soft', 'exe', 'dmg']

	attr_reader :type, :links, :root_url

	@@directories = []

	def initialize(url:, root_url:, type:)
		@url = url
		@root_url = root_url
		@type = set_type(type.downcase)
		@links = nil

		@@directories << self
	end

	def set_links()
		@links = DirectoryWrapper.get_directory_links(@url)
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
				return 'unknown'
			end
		else
			return @@TYPES.select { |t| type.include?(t) }.first
		end
	end

	def to_s()
		return "#{@type}: #{@links.length}"
	end

	def is_empty?
		return @links.length < 2
	end

	def is_root?
		return @url == @root_url
	end

	def self.get_directories()
		return @@directories
	end

	def self.get_directories_of_type(type)
		return @@directories.select { |dir| dir.type === type }
	end

end