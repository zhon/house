
require 'street_address'
require 'titleize'

class Address

  def self.normalize(s)
    address = StreetAddress::US.parse(s, informal: true)
    return s unless address
    unless address.city
      address = StreetAddress::US.parse(s + " UT", informal: true)
    end
    address.state = nil
    address.city = address.city.titleize if address.city
    if address.street
      address.street = address.street.titleize
      if address.suffix
        address.street += " #{address.suffix}"
        address.suffix = nil
      end
    end
    address.postal_code = nil
    address.postal_code_ext = nil
    address.to_s
  end

end
