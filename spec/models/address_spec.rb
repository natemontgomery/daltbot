require 'rails_helper'

RSpec.describe Address do
  describe '#fill_in_address_attrs' do
    it 'fills in values of all geocoded attributes' do
      address = nil

      VCR.use_cassette('geocoder/address-creation') do
        address = described_class.create!(raw_address: '123 SE 4th St New York, NY')
      end

      VCR.use_cassette('geocoder/address-lookup') do
        address.fill_in_address_attrs
      end

      expect(address).to have_attributes(
        city: "New York",
        postcode: "10036",
        locality: "Times Square",
        housenumber: "123",
        street: "West 43rd Street",
        district: "Manhattan",
        name: "The Town Hall",
        state: "New York"
      )
    end
  end
end
