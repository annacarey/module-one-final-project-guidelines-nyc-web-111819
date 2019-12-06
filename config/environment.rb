require 'bundler'
require 'sqlite3'
require "sinatra/activerecord"
require 'watir'
Bundler.require


ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
ActiveRecord::Base.logger = nil

require_all 'lib'
require_all 'app'

