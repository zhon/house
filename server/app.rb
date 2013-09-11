require 'sinatra'
require 'mongoid'
require 'json'
require 'chronic'

require "sinatra/reloader" if development?

require_relative 'app/seller/seller'
require_relative 'app/sale/sale'

Mongoid.load!("mongoid.yml")

set :public_folder, '../client/build' if development?

get '/api/sales' do
  Sale.all.order_by(:date.asc, :address.asc).to_json
end

get '/api/sellers' do
  Seller.all.to_json
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
    seller = Seller.where(name: sale['seller']).first

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
        county: sale['county'],
        owner: sale['owner']
      )

    now = Time.now
    sale.update_attributes(
      bid: sale['bid'],
      status: sale['status'],
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
        url: sale['url'],
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
