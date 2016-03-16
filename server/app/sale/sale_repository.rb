require_relative 'sale'
require_relative '../seller/seller'

require 'street_address_ext'

class SaleRepository
  class << self

    def update_from_trustee(item, seller)
      item = normalize item
      sale = find_or_create(item, seller)
      sale.update_sale(item)
      seller.update_scraped_at
      sale
    end

    def find_or_create(item, seller)
      find_by_address_case(item) ||
        find_by_case(item) ||
        find_by_address_owner_seller_county(item, seller) ||
        create_sale(item, seller)
    end

    def find_by_address_case(item)
      return nil if item[:address].to_s.empty?
      return nil if item[:case].to_s.empty?
      sale = Sale.where(address: item[:address]).first
      return nil unless sale
      if item[:case].index(sale[:case]) || sale[:case].index(item[:case])
        return sale
      end
      return nil
    end

    def find_by_case(item)
      #Sale.and( {:case => item['case']}, {seller_id: seller.id}).first
      item[:case] ? Sale.where(case: item[:case]).first : nil
    end

    def find_by_address_owner_seller_county(item, seller)
      return nil unless item[:address]
      Sale.and(
        {address: item[:address]},
        {owner: item[:owner]},
        {seller_id: seller.id},
        {county: item[:county]}
      ).first
    end

    def create_sale(item, seller)
      Sale.new(
        seller_id: seller.id,
        case: item[:case],
        address: item[:address],
        county: item[:county],
        owner: item[:owner]
      )
    end

    def normalize item
      item = item.dup
      address = StreetAddressExt.parse(item[:address])
      item[:address] = address.to_s if address
      case item[:status].to_s
      when :postponed.to_s
        if item[:postponed_to]
          item[:status] = ''
          item.delete :postponed
          item[:sale_date] = item.delete(:postponed_to)
        end
      end
      item
    end

  end
end
