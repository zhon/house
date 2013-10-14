require_relative '../helper'

require_relative '../../app/seller/seller'
require_relative '../../app/sale/sale'


describe Seller do

  describe 'update_scraped_at' do

    it 'sets scraped_at to Time.now' do
      now = Time.new(2013,10,14)
      seller = Seller.new
      mock(Time).now { now }
      mock(seller).scraped_at= now
      mock(seller).save
      seller.update_scraped_at
    end

  end

end
