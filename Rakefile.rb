require 'sinatra/activerecord'
require 'sinatra/activerecord/rake'
require './App'

task :console do
  byebug
end

task :scrape_opendirectories do
	resp = OpenURIWrapper.get('https://www.reddit.com/r/opendirectories/', 'opendirectories')
	n_resp = Nokogiri::HTML(resp)

	#Grab all the titles of each post on the front page of /r/opendirectories
	#Uses class of 'title may-blank outbound' to differentiate the post links from regular ones
	links = n_resp.xpath("//a[@class='title may-blank outbound']")

	links.each do |link|
		DirectoryScraper.start_scraping(link["href"])
	end
end