class Address < ApplicationRecord
  has_many :forecasts

  geocoded_by :raw_address
  reverse_geocoded_by :latitude, :longitude

  after_validation :geocode

  # Fill in all our attributes from geocoded raw address string.
  def fill_in_address_attrs
    geocoded_address_attrs = Geocoder.search([latitude, longitude]).first.data["properties"].slice(
      "country",
      "city",
      "postcode",
      "locality",
      "housenumber",
      "street",
      "district",
      "name",
      "state"
    )

    assign_attributes(geocoded_address_attrs)
  end
end
