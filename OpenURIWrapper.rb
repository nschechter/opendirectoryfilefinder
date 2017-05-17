require 'open-uri'

# Caches get requests to prevent unnecessary harm
class OpenURIWrapper
	def self.get(url, file_name)
		cache_dir = File.dirname(__FILE__) + "/tmp/#{file_name}"
		if File.exists?(cache_dir)
			puts "exists"
			return IO.read(cache_dir)
		else
			resp = open(url)
			data = resp.read
			File.open(cache_dir, 'w') do |f|
        f.puts data
      end
      puts "writing"
      return data
		end
	end
end