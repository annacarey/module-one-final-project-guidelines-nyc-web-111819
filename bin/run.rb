require_relative '../config/environment'
require 'rest-client'
require 'json'
require 'pry'


#pid = fork{ exec ‘mpg123’,'-q', '/lib/music/Kanye-West-all-of-the-lights-feat.-Rihanna (1).mp3' }

#pid = fork{ exec ‘killall’, “afplay” }

new_cli = CLI.new 
new_cli.run



puts "HELLO WORLD"
