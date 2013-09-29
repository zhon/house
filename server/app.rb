require 'sinatra'
require 'mongoid'
require 'json'
require 'chronic'

require "sinatra/reloader" if development?

require_relative 'app/seller/seller'
require_relative 'app/seller/seller_repository'
require_relative 'app/sale/sale'
require_relative 'app/sale/sale_repository'


before '/api/*' do
  content_type :json
end

load 'app/sale/route.rb'
load 'app/seller/route.rb'

Mongoid.load!("mongoid.yml")

if development?
  set :public_folder, '../client/build'

  get '/' do
    send_file File.expand_path('index.html', settings.public_folder)
  end

  #get '/*' do
    #redirect '/'
  #end
end

