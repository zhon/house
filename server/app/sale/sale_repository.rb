require_relative 'sale'
require_relative '../seller/seller'
require_relative '../common/address'

class SaleRepository

  def self.update_from_trustee(item, seller)
    item[:address] = Address.normalize(item[:address]) if item[:address]
    sale = find_or_create(item, seller)
    sale.update_sale(item)
    seller.update_scraped_at
    sale
  end

  def self.find_or_create(item, seller)
    find_by_case(item) ||
    find_by_address_owner_seller_county(item, seller) ||
    create_sale(item, seller)
  end

  def self.find_by_case(item)
    #Sale.and( {:case => item['case']}, {seller_id: seller.id}).first
    item[:case] ? Sale.where(case: item[:case]).first : nil
  end

  def self.find_by_address_owner_seller_county(item, seller)
    Sale.and(
      {address: item[:address]},
      {owner: item[:owner]},
      {seller_id: seller.id},
      {county: item[:county]}
    ).first
  end

  def self.create_sale(item, seller)
    Sale.new(
      seller_id: seller.id,
      case: item[:case],
      address: item[:address],
      county: item[:county],
      owner: item[:owner]
    )
  end

end
