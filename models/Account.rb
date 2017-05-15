require 'sinatra/activerecord'

class Account < ActiveRecord::Base
	has_secure_password
end