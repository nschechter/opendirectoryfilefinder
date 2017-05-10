require_relative './GoogleSearcher'
require 'httparty'
require 'nokogiri'
require 'byebug'

class DirCollector
	def initialize(type)
		@type = type
	end

	def start_scraper()
		scrape(@type)
	end

	def scrape(type)
		GoogleSearcher.search("movies")
	end
end