
get '/api/sales' do
  Sale.all.order_by(:date.asc, :address.asc).to_json(include: :seller)
end

get '/api/sale/:id' do
  Sale.where(_id: params[:id]).to_json
end

put '/api/sale/:id' do
  Sale.where(_id: params[:id]).
    find_and_modify('$set' => JSON.parse(request.body.read))
end

delete '/api/sale/:id' do
  Sale.where(_id: params[:id]).destroy
  ''
end

post '/api/sales' do
  content_type :json

  JSON.parse(request.body.read, :symbolize_names => true).each do |item|
    seller = SellerRepository.find_or_create(nil, item[:seller])
    SaleRepository.update_from_trustee(item, seller)
  end
  ''
end

