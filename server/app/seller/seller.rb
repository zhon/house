
require 'mongoid'

class Seller
  include Mongoid::Document

  has_many :sales

  field :name, type: String
  field :phone, type: String
  field :url, type: String
  field :scrapable, type: String
  field :scraped_at, type: Time
end

