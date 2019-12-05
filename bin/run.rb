require_relative '../config/environment'
require 'rest-client'
require 'json'
require 'pry'


#pid = fork{ exec ‘mpg123’,'-q', '/lib/music/Kanye-West-all-of-the-lights-feat.-Rihanna (1).mp3' }

#pid = fork{ exec ‘killall’, “afplay” }

new_cli = CLI.new 
new_cli.run

<<<<<<< HEAD
=======
# artist_string = RestClient.get("https://api.songkick.com/api/3.0/artists/110449/calendar.json?apikey=io09K9l3ebJxmxe2")
# artist_hash = JSON.parse(artist_string)
# binding.pry

>>>>>>> anna-2


puts "HELLO WORLD"
