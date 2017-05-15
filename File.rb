require "open-uri"

class File
	@@file_queue = []

	attr_reader :name

	def initialize(name:, url:)
		@name = name
		@url = url
		@status = "Uncomplete"
		@@file_queue << self
	end

	def download
		@status = "Downloading"
		`wget '#{url}'`
	end

	def self.get_queue()
		return @@file_queue
	end

end