class SmartDirScraper
	def initialize(url, search_term)
		@base_url = url
		@url_history = []
		@search_term = search_term
		@results = []
	end

	def start_scraping()
		scrape(@base_url)
	end

	def scrape(url)
		response = HTTParty.get(url)
		case response.code
		when 200
			n_response = Nokogiri::HTML(response)
			links = resp.css('a')
			@results = links.select { |link| link["href"].upcase.include?(@search_term) }
			if @results.empty? 

			else

			end
		when 404
			puts "damn"
		else
			puts "damn"
	end
end