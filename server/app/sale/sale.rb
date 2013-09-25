require 'mongoid'
require 'chronic'

class Sale
  include Mongoid::Document

  belongs_to :seller

  field :case, type: String
  field :address, type: String
  field :bid, type: String
  field :date, type: Time
  field :county, type: String
  #field :seller_id, type: Moped::BSON::ObjectId
  field :owner, type: String
  field :rank, type: Integer
  field :url, type: String
  field :updated_at, type: Time

  def serializable_hash(options={})
    hash = super(options)
    hash[:seller_name] = seller.name
    hash
  end

  def update_sale(item)
    data = {
      date: Chronic.parse(item[:sale_date]),
      updated_at: Time.now
    }
    data[:bid] = item[:bid] if item[:bid]
    data[:owner] = item[:owner] if item[:owner] #TODO consider keeping owner from paper
    data[:county] = item[:county] if item[:county]
    data[:case] = item[:case] if item[:case]
    data[:url] = item[:url] if item[:url]
    data[:status] = item[:status] if item[:status]

    update_attributes(
      data
    )
    save
  end

end

