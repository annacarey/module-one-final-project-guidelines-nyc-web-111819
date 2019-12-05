require_relative '../config/environment'
require 'rest-client'
require 'json'
require 'pry'


new_cli = CLI.new 
new_cli.run

# artist_string = RestClient.get("https://api.songkick.com/api/3.0/artists/110449/calendar.json?apikey=io09K9l3ebJxmxe2")
# artist_hash = JSON.parse(artist_string)
# binding.pry



puts "HELLO WORLD"
