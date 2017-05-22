require 'sinatra/base'
require 'byebug'
require 'rufus-scheduler'
require_relative './DirectoryScraper'
require_relative './models/Account'
require_relative './models/OpenDir'
require_relative './OpenURIWrapper'
require 'bcrypt'

class App < Sinatra::Base

  scheduler = Rufus::Scheduler.new

  # Scheduled to scrape reddit every 24 hours.
  scheduler.every '1d' do
      DirectoryScraper.scrape_reddit()
  end

  configure do
    enable :sessions
  end

	before do
	  @logged_in = !session[:account_id].nil?
    if !logged_in?
      redirect '/login'
    end
	end

  get '/' do
    redirect '/panel'
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
      redirect '/login'
  	end
  end

  post '/directories' do
  	puts params[:url]
		DirectoryScraper.start_scraping(params[:url], params[:type])
		erb :cpanel
  end

  get '/panel' do
    if params[:file_name]
      @file_name = OpenDir.get_file_link_from_directories(params[:file_name], params[:file_type].downcase)
    end
		erb :cpanel
  end

  post '/reddit' do
    DirectoryScraper.scrape_reddit()
    redirect '/panel'
  end

  get '/directories' do
    @root_directories = OpenDir.where('url = root_url')
		erb :directories
  end

  patch '/directories/:id' do
    dir = OpenDir.find(params[:id])
    dir.force_update(dir.root_url)
    redirect '/directories'
  end

  delete '/directories/:id' do
    dir = OpenDir.find(params[:id])
    OpenDir.where(root_url: dir.root_url).destroy_all
    redirect '/directories'
  end

  private
  def logged_in?
  	return !session[:account_id].nil?
	end
end