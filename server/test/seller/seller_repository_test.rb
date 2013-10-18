require_relative '../helper'

require_relative '../../app/seller/seller_repository'


describe SellerRepository do

  describe 'find_or_create' do

    it 'finds by phone first' do
      phone = 'phone number'
      mock(Seller).where(phone: phone) { [stub(Seller.new)] }
      SellerRepository.find_or_create(phone, name)
    end

    it 'finds by name second' do
      name = 'seller name'
      mock(Seller).where(name: name) { [stub(Seller.new)] }
      SellerRepository.find_or_create(nil, name)
    end

    it 'creates new seller' do
      name = 'seller name'
      phone = '555.555.1234'
      stub(Seller).where(phone: phone) { [] }
      stub(Seller).where(name: name) { [] }
      mock(Seller).create(phone: phone, name: name)
      SellerRepository.find_or_create(phone, name)
    end

    it 'returns a seller' do
      stub(seller = Seller.new)
      stub(Seller).where { [ seller ] }
      SellerRepository.find_or_create(nil, nil).must_equal seller
    end

  end

end
