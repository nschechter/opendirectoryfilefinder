require_relative 'DirectoryWrapper'

class Directory

	attr_reader :type, :links, :root_url

	@@directories = []

	def initialize(url:, root_url:)
		@url = url
		@root_url = root_url
		@type = nil
		@links = nil

		@@directories << self
	end

	def set_links()
		@links = DirectoryWrapper.get_directory_links(@url)
		set_type()
	end

	def set_type()
		byebug
		@links.reduce { |link| }
	end

	def to_s()
		return "#{@type}: #{@links.length}"
	end

	def is_empty?
		
	end

	def self.get_directories()
		return @@directories
	end

	def self.get_directories_of_type(type)
		case type
		when "movies"
			return @@directories.select { |dir| dir.type === "movies" }
		when "tv"
			return @@directories.select { |dir| dir.type === "tv" }
		when "music"
			return @@directories.select { |dir| dir.type === "music" }
		else
			return @@directories
		end
	end
end