
get '/api/sellers' do
  Seller.order_by(:scrapable.desc, :name.asc).to_json
end

get '/api/seller/:id' do
  Seller.where(_id: params[:id]).first
end

