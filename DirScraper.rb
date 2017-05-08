require 'byebug'
require 'HTTParty'
require 'nokogiri'

SHOW_KEYWORDS = ['SERIE', 'SHOW', 'TV', 'TELEVISION', 'SERIAL']

class DirScraper
	def initialize(url, name)
		@url = url
		@search_item = name
		@shows_url = ''
		@movies_url = ''
		@games_url = ''
	end

	def scrape()
		response = HTTParty.get(@url)
		n_response = Nokogiri::HTML(response)
		find_directory('shows', n_response)
	end

	private
	def find_directory(type, resp)
		links = resp.css('a')
		case type
		when 'shows'
			show_links = links.select { |link| SHOW_KEYWORDS.any? { |key| link["href"].upcase.include?(key) } }
			@shows_url = @url + "#{show_links.last['href']}"
		when 'movies'

		when 'games'

		else
			puts 'bug!'
		end
	end

end