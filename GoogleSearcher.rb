require 'Nokogiri'
require 'HTTParty'
require 'byebug'
require 'google/apis/customsearch_v1'

class GoogleSearcher
	def initialize()
	end

	def self.search(keyword)
		key = YAML.load_file("secrets.yml").values[0]
		url = "https://www.googleapis.com/customsearch/v1?key=#{key}&q=#{keyword}"
		# response = HTTParty.get(url)
		search = Google::Apis::CustomsearchV1::CustomsearchService.new
		search.key = key
		byebug
	end
end