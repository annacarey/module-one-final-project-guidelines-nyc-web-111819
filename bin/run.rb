require_relative '../config/environment'
require 'rest-client'
require 'json'
require 'pry'


new_cli = CLI.new 
new_cli.run

puts "HELLO WORLD"
