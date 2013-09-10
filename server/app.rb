require 'sinatra'
require 'mongoid'
require 'json'
require 'chronic'
require "sinatra/reloader" if development?

Mongoid.load!("mongoid.yml")

set :public_folder, '../client/build' if development?

class Seller
  include Mongoid::Document

  field :name, type: String
  field :phone, type: String
  field :url, type: String
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
  field :url, type: String
  field :updated_at, type: Time
  field :scraped_at, type: Time
end

get '/api/sales' do
  Sale.all.to_json
    #.sort(['date', 'desc'],['address', 'desc'])
end

get '/seller/:id' do
  content_type :json
  Seller.where(seller_id: params[:id])
end

before '/api/*' do
  content_type :json
end

post '/api/t_sales' do
  #content_type :json
  JSON.parse(request.body.read).each do |sale|
     #find seller from phone or name
    seller = Seller.find(
      {name: sale['seller']}
    ).first

    sale_date = Chronic.parse(sale['sale_date'])
    sale = 
      Sale.and( {:case => sale['case']}, {seller_id: seller.id}).first ||
      Sale.and(
               {address: sale['address']},
               {owner: sale['owner']},
               {seller_id: seller.id},
               {county: sale['county']}
              ).first ||
      Sale.new(
        seller_id: seller.id,
        case: sale['case'],
        address: sale['address'],
        bid: sale['bid'],
        date: sale_date,
        status: sale['status'],
        county: sale['county'],
        owner: sale['owner']
      )

    now = Time.now
    sale.update_attributes(
      date: sale_date,
      updated_at: now,
      scraped_at: now
    )
    sale.save
  end
  ''
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

    sale_date = Chronic.parse(sale['sale_date'])
    sale = 
      Sale.and( {:case => sale['case']}, {seller_id: seller.id}).first ||
      Sale.and(
               {address: sale['address']},
               {owner: sale['owner']},
               {seller_id: seller.id},
               {county: sale['county']}
              ).first ||
      Sale.new(
        seller_id: seller.id,
        case: sale['case'],
        address: sale['address'],
        bid: sale['bid'],
        url: sale['url']
        date: sale_date,
        county: sale['county'],
        owner: sale['owner']
      )
    now = Time.now
    sale.update_attributes(
      date: sale_date,
      updated_at: now,
      scraped_at: now
    )
    sale.save
  end
  ''
end

get '/' do
  send_file File.expand_path('index.html', settings.public_folder)
end

get '/*' do
  redirect '/'
end


__END__

  create_table "sales", :force => true do |t|
    t.integer  "seller_id", :null => false
    t.string   "bid"
    t.datetime "date"
    t.string   "county"
    t.string   "owner"
    t.string   "case"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rank",       :default => 0
    t.datetime "scraped_at"
    t.string   "url"
  end

  create_table "sellers", :force => true do |t|
    t.string   "name",       :limit => 40
    t.string   "url"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "scrapable"
    t.datetime "scraped_at"
  end
