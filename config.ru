require_relative './App'

use Rack::MethodOverride
run App.new