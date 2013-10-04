require_relative '../helper'


require_relative '../../app/common/address'

require 'json'


describe Address do

  describe 'normalize' do

    it 'changes nothing if not really an address' do
      Address.normalize('junk').must_equal 'junk'
    end

    it 'removes the state' do
      Address.normalize('2525 S 300 W, Layton UT').must_equal '2525 S 300 W, Layton'
    end

    it 'titleizes city' do
      Address.normalize('2525 S 300 W, LAYTON UT').must_equal '2525 S 300 W, Layton'
    end

    it 'titleizes street' do
      Address.normalize('3434 LAYTON STREET, LAYTON UT').must_equal '3434 Layton St, Layton'
    end

    it 'removes zip code' do
      Address.normalize('2525 S 300 W, Layton UT 84022-1111').must_equal '2525 S 300 W, Layton'
    end

    it 'works when missing State' do
      Address.normalize('2525 S 300 W, Layton').must_equal '2525 S 300 W, Layton'
    end

    describe 'to_s' do

      it 'version bomb (try removing hack if new version)' do
        StreetAddress::US::VERSION.must_equal '1.0.5'
      end

      it 'displays suffix before unit & unit_prefix' do
        #p StreetAddress::US.parse(
          #'88 W 50 S Unit Q-20, Centerville',
          #informal: true)
        Address.normalize(
          '88 W 50 S Unit Q-20, Centerville'
        ).must_equal(
          '88 W 50 S Unit Q-20, Centerville'
        )
      end

    end


  end

end
