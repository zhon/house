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

    describe 'when status is postponed, update_sale is called with' do

      it 'only sale_date if status is :postponed' do
        time = 'next month'
        @sale_hash = { status: :postponed, postponed_to: time}
        stub(SaleRepository).find_or_create do
          mock('sale').update_sale( {status: '', sale_date: time} )
        end
        SaleRepository.update_from_trustee(@sale_hash, @nil_seller)
      end

      it 'original hash if missing :postponed_to' do
        @sale_hash = { status: :postponed, sale_date: 'today' }.freeze
        stub(SaleRepository).find_or_create do
          mock('sale').update_sale(@sale_hash)
        end
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

  describe 'find_by_address_case' do

    it 'returns nil when item[:address] is nil or empty' do
      sale = {
        address: nil,
        case: "case_no",
      }
      SaleRepository.find_by_address_case(sale).must_equal nil
    end

    it 'returns nil when item[:case] is nil or empty' do
      sale = {
        address: "address",
        case: "",
      }
      SaleRepository.find_by_address_case(sale).must_equal nil
    end

    it 'returns nil if no sale with address is found' do
      sale = {
        address: "address",
        case: "",
      }
      sale_db = nil
      stub(Sale).where { [] }
      SaleRepository.find_by_address_case(sale).must_equal nil
    end

    it 'returns nil if case doesnt match' do
      sale = {
        address: "address",
        case: "123",
      }
      sale_db = sale.dup
      sale_db[:case] = "case"
      stub(Sale).where { [sale_db] }
      SaleRepository.find_by_address_case(sale).must_equal nil
    end

    it 'returns valid db sale when cases match' do
      sale = {
        address: "address",
        case: "123456",
      }
      sale_db = sale.dup
      sale_db[:case] = "123"
      stub(Sale).where.with_any_args { [sale_db] }
      SaleRepository.find_by_address_case(sale).must_equal sale_db
    end

    it 'returns valid when db_sale.case is superset of sale.case' do
      sale = {
        address: "address",
        case: "123",
      }
      sale_db = sale.dup
      sale_db[:case] = "A123B"
      stub(Sale).where.with_any_args { [sale_db] }
      SaleRepository.find_by_address_case(sale).must_equal sale_db
    end

    it 'returns nil when db_sale.case & sale.case dont match' do
      sale = {
        address: "address",
        case: "123",
      }
      sale_db = sale.dup
      sale_db[:case] = "ABCD"
      stub(Sale).where.with_any_args { [sale_db] }
      SaleRepository.find_by_address_case(sale).must_equal nil
    end

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

    it 'returns nil if no address' do
      SaleRepository.find_by_address_owner_seller_county({}, nil).must_equal nil
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
