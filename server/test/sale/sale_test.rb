require_relative '../helper'

require_relative '../../app/sale/sale'
require_relative '../../app/seller/seller'

require 'json'


describe Sale do

  describe 'to_json' do

    before do
      @sale = Sale.new(case: 'case 666')
      @sale.seller = Seller.new(:name => 'Sam Norris')
    end

    it 'has original data' do
      JSON.parse(@sale.to_json)['case'].must_equal 'case 666'
    end

  end


  describe 'update_sale' do

    it 'calls update_attributes then save' do
      sale_hash = {
        sale_date: 'Tomorrow',
        case: 'case_id',
        bid: '$bid',
        address: 'address',
        county: 'county',
        owner: 'owner',
      }
      stub(Time).now { Time.new(2013,9,25) }
      mock(sale = Sale.new).update_attributes({
        date: Chronic.parse(sale_hash[:sale_date]),
        case: sale_hash[:case],
        bid: sale_hash[:bid],
        address: sale_hash[:address],
        owner: sale_hash[:owner],
        county: sale_hash[:county],
        #url: sale_hash[:url],
        updated_at: Time.now,
      })
      mock(sale).save
      sale.update_sale(sale_hash)
    end

  end

end
