require 'sinatra/base'
require 'byebug'
require_relative './DirectoryScraper'

class App < Sinatra::Base
	@@logged_in = false

	before do
	  @logged_in = @@logged_in
	end

  get '/' do
  	if logged_in?
    	redirect '/panel'
    else
    	redirect '/login'
    end
  end

  get '/login' do
  	erb :login
  end

  post '/sessions' do
  	if params[:username] === 'noah' && params[:password] === 'noah'
  		@@logged_in = true
  		redirect '/panel'
  	else
  		@error = "Incorrect username or password."
  	end
  end

  post '/directories' do
  	puts params[:url]
		DirectoryScraper.start_scraping(params[:url], false)
		erb :cpanel
  end

  get '/panel' do
  	if logged_in?
  		erb :cpanel
  	else
  		redirect '/login'
  	end
  end

  post '/download' do
  	puts params.to_s
  	redirect '/panel'
  end

  get '/directories' do
  	if logged_in?
  		erb :directories
  	else
  		redirect '/login'
  	end
  end

  private
  def logged_in?
  	return @@logged_in
	end
end