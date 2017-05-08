require 'httparty'
require 'nokogiri'
require 'byebug'
require_relative "./Google"

class DirCollecter
	def initialize(type)
		@type = type
	end

	def start_scraper()
		scrape(@type)
	end

	private
	def scrape(type)
		byebug
	end
end