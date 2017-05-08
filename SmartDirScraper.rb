require 'byebug'
require 'HTTParty'
require 'nokogiri'

class SmartDirScraper
	def initialize(url, search_term)
		@base_url = url
		@current_index = 1
		@search_term = search_term
		@results = nil
	end

	def start_scraping()
		scrape_dir(@base_url)
	end

	def scrape_dir(url)
		response = HTTParty.get(url)
		case response.code
		when 200
			n_response = Nokogiri::HTML(response)
			links = n_response.css('a')
			links = links.select { |link| !has_extension?(link["href"]) }
			@results = links.select { |link| link.text.upcase.include?(@search_term.upcase) }
			if @results.empty? && links.length > 1
				if url === @base_url
					puts "Searching #{url + links[@current_index]['href']}"
					scrape_dir(url + links[@current_index]["href"])
				else
					puts "Searching #{url + links[1]['href']}"
					scrape_dir(url + links[1]["href"])
				end
			elsif links.length === 1
				@current_index += 1
				scrape_dir(@base_url)
			else
				@results.each { |result| puts "Found #{result.text} @ #{url + result['href']}" }
			end
		when 404
			puts "ERROR - #{url} not found"
		else
			puts "Uh oh..."
		end
	end

	private
	def has_extension?(url)
		return url.match(/(.)([a-zA-Z0-9]+)$/)
	end
end