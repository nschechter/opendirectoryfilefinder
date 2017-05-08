require 'byebug'
require 'HTTParty'
require 'nokogiri'

class SmartDirScraper
	def initialize(url, search_term)
		@base_url = url
		@current_index = 1
		@max_searches = 10000000
		@search_term = search_term
		@results = nil
	end

	def start_scraping()
		scrape_dir(@base_url)
	end

	def scrape_dir(url)
		if @current_index < @max_searches
			response = HTTParty.get(url)
			case response.code
			when 200
				n_response = Nokogiri::HTML(response)
				if (@max_searches === 10000000 && @base_url === url)
					@max_searches = n_response.css('a').select { |link| !has_extension?(link["href"]) }.length
					puts "Max Searches: #{@max_searches}"
				end
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
				puts "ERROR - #{url} not found (Maybe try again later?)"
			else
				puts "Uh oh..."
			end
		else
			puts "No results for #{@search_term} found."
		end
	end

	private
	def has_extension?(url)
		return url.match(/(.)([a-zA-Z0-9]+)$/)
	end
end