require_relative 'seller'

class SellerRepository

  def self.find_or_create(phone, name)
    seller = Seller.where(phone: phone).first if phone
    seller = Seller.where(name: name).first unless seller
    seller = Seller.create(phone: phone, name: name) unless seller
    seller
  end

end
