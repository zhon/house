require 'sinatra'
require 'mongoid'
require 'json'
require "sinatra/reloader" if development?

Mongoid.load!("mongoid.yml")


class Seller
  include Mongoid::Document

  field :name, type: String
  field :phone, type: String
  field :scraped_at, type: Time
  field :updated_at, type: Time
end

class Sale
  include Mongoid::Document

  field :case, type: String
  field :address, type: String
  field :bid, type: String
  field :date, type: Time
  field :county, type: String
  field :seller_id, type: Moped::BSON::ObjectId
  field :owner, type: String
  field :rank, type: Integer
  field :updated_at, type: Time
  field :scraped_at, type: Time
end

before 'api/*' do
end

get '/sales' do
  content_type :json
  Sale.all.to_json
    .sort(['date', 'desc'],['address', 'desc'])
end

get '/seller/:id' do
  content_type :json
  Seller.where(seller_id: params[:id])
end

post '/api/ul_sales' do
  #content_type :json
  JSON.parse(request.body.read).each do |sale|
     #find seller from phone or name
    seller = Seller.or(
      {phone: sale['seller_phone']},
      {name: sale['seller']}
    ).first

    seller = Seller.create(
      name: sale['seller'],
      phone: sale['seller_phone']
    ) unless seller

    Sale.create(
      seller_id: seller.id,
      case: sale['case'],
      address: sale['address'],
      bid: sale['bid'],
      date: sale['date'],
      county: sale['county'],
      owner: sale['owner']
    )

  end
  ''
end


__END__

  create_table "addresses", :force => true do |t|
    t.integer  "sale_id"
    t.string   "house"
    t.string   "street"
    t.string   "city"
    t.string   "state",      :default => "UT"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sales", :force => true do |t|
    t.integer  "seller_id",                 :null => false
    t.string   "bid"
    t.datetime "date"
    t.string   "county"
    t.string   "owner"
    t.string   "case"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rank",       :default => 0
    t.datetime "scraped_at"
  end

  create_table "sellers", :force => true do |t|
    t.string   "name",       :limit => 40, :null => false
    t.string   "url"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "scrapable"
    t.datetime "scraped_at"
  end
