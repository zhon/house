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

Mongoid.load!("mongoid.yml")

set :public_folder, '../client/build' if development?

get '/api/sellers' do
  Seller.all.to_json
    #.sort(['date', 'desc'],['address', 'desc'])
end

get '/seller/:id' do
  content_type :json
  Seller.where(seller_id: params[:id])
end


get '/' do
  send_file File.expand_path('index.html', settings.public_folder)
end if development?


get '/*' do
  redirect '/'
end if development?

