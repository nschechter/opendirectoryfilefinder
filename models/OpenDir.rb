require 'sinatra/activerecord'

class OpenDir < ActiveRecord::Base

	TYPES = ['root', 'movie', 'tv', 'music']
	MOVIE_TYPES = ['moving pictures', 'film', 'motion picture', 'features']
	TV_TYPES = ['serie', 'tele', 'show', 'serial', 'video', 'anime']
	MUSIC_TYPES = ['album', 'song', 'cassette', 'vinyl', 'podcast', 'radio']
	SOFTWARE_TYPES = ['game', 'soft', 'exe', 'dmg', 'wares']
	EBOOK_TYPES = ['book', 'mobi', 'read', 'text', 'instruction']

	# After initializing the model, update the type.
	after_initialize do |dir|
		dir.update!(dir_type: set_type(dir.dir_type))
	end

	def self.set_links(dir)
		dir_links, file_links = DirectoryWrapper.get_links_from_directory(@url, @root_url)
		dir.update!(dir_links: dir_links, file_links: file_links, scraped: true)
	end

	def self.get_unscraped_directories_from_root_url(root_url)
		return OpenDir.all.select { |dir| !dir.scraped && dir.root_url === root_url }
	end

	def self.get_directory_from_url(url)
		return OpenDir.all.find { |dir| dir.url === url }
	end

	def set_type(type)
		if !TYPES.any? { |t| type.include?(t) }
			if MOVIE_TYPES.any? { |t| type.include?(t) }
				return 'movie'
			elsif TV_TYPES.any? { |t| type.include?(t) }
				return 'tv'
			elsif MUSIC_TYPES.any? { |t| type.include?(t) }
				return 'music'
			elsif SOFTWARE_TYPES.any? { |t| type.include?(t) }
				return 'software'
			elsif EBOOK_TYPES.any? { |t| type.include?(t) }
				return 'ebook'
			else
				return type
			end
		else
			return TYPES.select { |t| type.include?(t) }.first
		end
	end

	def to_s()
		return "#{@type}: #{@dir_links.length} - #{@file_links.length}"
	end
end