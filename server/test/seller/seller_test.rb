require_relative '../helper'

require_relative '../../app/seller/seller'
require_relative '../../app/sale/sale'


describe Seller do

  describe 'update_scraped_at' do

    it 'sets scraped_at to Time.now' do
      now = 'Time.now' #2013, 10, 11
      mock(Time).now { now }
      stub(seller=Seller.new).update_attributes(
        scraped_at: now
      )
      seller.update_scraped_at
    end

  end

end
