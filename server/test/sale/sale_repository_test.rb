require_relative '../helper'

require_relative '../../app/sale/sale_repository'


describe SaleRepository do

  describe 'update_from_trustee' do

    before do
      @sale_hash={}
      stub(@nil_seller = Seller.new).update_scraped_at
    end

    it 'finds or creates the sale and update it' do
      mock(SaleRepository).find_or_create(@sale_hash, @nil_seller) {
        mock(Sale.new).update_sale(@sale_hash)
      }
      SaleRepository.update_from_trustee(@sale_hash, @nil_seller)
    end

    it 'updates seller scraped_at' do
      stub(repo = SaleRepository).find_or_create do
        stub('sale').update_sale
      end
      mock(seller = Seller.new).update_scraped_at
      repo.update_from_trustee(@sale_hash, seller)
    end

    describe 'normalizes address' do

      before do
        stub(SaleRepository).find_or_create(@sale_hash, @nil_seller) {
          stub(Sale.new).update_sale(@sale_hash)
        }
      end

      it 'updates sale_hash' do
        @sale_hash = {
          address: '328 Chauncey Street, Brooklyn, NY'
        }
        mock(Address).normalize(@sale_hash[:address]) {
          'a normalized address'
        }
        SaleRepository.update_from_trustee(@sale_hash, @nil_seller)
        @sale_hash[:address].must_equal 'a normalized address'
      end

      it 'is NOT called when sale[:address] is nil' do
        mock(Address).normalize.never
        SaleRepository.update_from_trustee(@sale_hash, @nil_seller)
      end

    end

  end

  describe 'find_or_create' do

    before do
      stub(@seller = Seller.new).id { 'seller_id' }
    end

    it 'finds by case first' do
      sale_hash = { }
      mock(SaleRepository).find_by_case(sale_hash) { stub(Sale.new) }
      SaleRepository.find_or_create(sale_hash, @seller)
    end

    it 'finds by address, owner, seller, & county second' do
      sale_hash = { }
      mock(SaleRepository).find_by_case(sale_hash)
      mock(SaleRepository).find_by_address_owner_seller_county(sale_hash, @seller) { stub(Sale.new) }
      SaleRepository.find_or_create(sale_hash, @seller)
    end

    it 'lastly creates a new sale' do
      sale_hash = { }
      mock(SaleRepository).find_by_case(sale_hash)
      mock(SaleRepository).find_by_address_owner_seller_county(sale_hash, @seller)
      mock(SaleRepository).create_sale(sale_hash, @seller)
      SaleRepository.find_or_create(sale_hash, @seller)
    end

  end

  describe 'find_by_case' do

    it '' do
      sale_hash = { case: '2003XP' }
      mock(Sale).where(case: sale_hash[:case]) { mock([]).first }
      SaleRepository.find_by_case(sale_hash)
    end

    it 'returns nil if sale[case:] is nil' do
      SaleRepository.find_by_case( {} ).must_equal nil
    end

  end

  describe 'find_by_address_owner_seller_county' do
    it '' do
      sale_hash = { 
        address: 'address',
        owner: 'owner',
        county: 'county',
      }
      stub(seller = Seller.new).id { 'seller_id' }
      mock(Sale).and(
        {address: sale_hash[:address]},
        {owner: sale_hash[:owner]},
        {seller_id: seller.id },
        {county: sale_hash[:county]}
      ) { mock([]).first }
      SaleRepository.find_by_address_owner_seller_county(sale_hash, seller)
    end
  end

  describe 'create_sale' do
    it '' do
      sale_hash = { 
        case: 'case_id',
        address: 'address',
        county: 'county',
        owner: 'owner',
      }
      stub(seller = Seller.new).id { 'seller_id' }
      mock(Sale).new(
        seller_id: seller.id,
        case: sale_hash[:case],
        address: sale_hash[:address],
        county: sale_hash[:county],
        owner: sale_hash[:owner]
      ) {
        stub([]).first
      }
      SaleRepository.create_sale(sale_hash, seller)
    end
  end


end
