require_relative '../helper'

require_relative '../../app/seller/seller'
require_relative '../../app/sale/sale'

require 'timecop'


describe Seller do

  describe 'update_scraped_at' do

    it 'sets scraped_at to Time.now' do
      now = Time.new(2013, 10, 14)
      Timecop.freeze(now) do
        stub(seller = Seller.new).save
        seller.update_scraped_at
        seller.scraped_at.must_equal now
      end
    end

  end

end
