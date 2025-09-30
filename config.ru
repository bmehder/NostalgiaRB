# config.ru
require_relative './app'  # loads your app.rb

# If you're using classic Sinatra (require 'sinatra'), this will be the app:
run Sinatra::Application