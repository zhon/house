
require 'mongoid'

class Seller
  include Mongoid::Document

  field :name, type: String
  field :phone, type: String
  field :url, type: String
  field :scraped_at, type: Time
  field :updated_at, type: Time
end

