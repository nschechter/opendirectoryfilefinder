require 'sinatra/base'
require 'byebug'
require_relative './DirectoryScraper'
require_relative './models/Account'
require_relative './models/OpenDir'
require 'bcrypt'

#set :database, {adapter: "postgresql", database: "db.db"}

class App < Sinatra::Base
  configure do
    enable :sessions
  end

	before do
	  @logged_in = !session[:account_id].nil?
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
    account = Account.find_by(username: params[:username])
    if account && account.authenticate(params[:password])
  		session[:account_id] = account.id
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
  	puts OpenDir.get_file_link_from_directories(params[:download], OpenDir.all)
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
  	return !session[:account_id].nil?
	end
end