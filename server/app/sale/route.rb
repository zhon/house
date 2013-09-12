
get '/api/sales' do
  Sale.all.order_by(:date.asc, :address.asc).to_json
end

get '/api/sale/:id' do
  Sale.where(_id: params[:id]).to_json
end

delete '/api/sale/:id' do
  Sale.where(_id: params[:id]).destroy
end


post '/api/t_sales' do
  content_type :json

  JSON.parse(request.body.read).each do |item|
    seller = Seller.where(name: item['seller']).first

    sale_date = Chronic.parse(item['sale_date'])
    sale =
      Sale.and( {:case => item['case']}, {seller_id: seller.id}).first ||
      Sale.and(
               {address: item['address']},
               {owner: item['owner']},
               {seller_id: seller.id},
               {county: item['county']}
              ).first ||
      Sale.new(
        seller_id: seller.id,
        case: item['case'],
        address: item['address'],
        county: item['county'],
        owner: item['owner']
      )

    now = Time.now
    sale.update_attributes(
      bid: item['bid'],
      status: item['status'],
      date: sale_date,
      updated_at: now
    )
    sale.save
  end
  ''
end


  # TODO fix bug with sale item & db sale 
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
