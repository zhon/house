
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

end

