require 'sinatra/activerecord'
require 'sinatra/activerecord/rake'
require './App'

task :console do
  byebug
end