require 'minitest/autorun'

require_relative '../../app/sale/sale'
require_relative '../../app/seller/seller'

require 'json'

require 'rr'

describe Sale do

  describe 'to_json' do

    before do
      @sale = Sale.new(case: 'case 666')
      @sale.seller = Seller.new(:name => 'Sam Norris')
    end

    it 'has seller_name' do
      JSON.parse(@sale.to_json)['seller_name'].must_equal 'Sam Norris'
    end

    it 'has original data' do
      JSON.parse(@sale.to_json)['case'].must_equal 'case 666'
    end

  end

end
