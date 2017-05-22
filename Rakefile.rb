require 'sinatra/activerecord'
require 'sinatra/activerecord/rake'
require_relative './App'

task :console do
  byebug
end

task :scrape_opendirectories do
	DirectoryScraper.scrape_reddit()
end