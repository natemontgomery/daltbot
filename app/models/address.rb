class Address < ApplicationRecord
  has_many :forecasts

  geocoded_by :raw_address
  reverse_geocoded_by :latitude, :longitude

  after_validation :geocode

  # Fill in all our attributes from geocoded raw address string.
  def fill_in_address_attrs
    reverse_geocoded_data = Geocoder.search([latitude, longitude]).first.data
    geocoded_address_attrs = reverse_geocoded_data["properties"].slice(
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

  def display_address
    "#{street} #{housenumber} #{city}, #{state} #{postcode}"
  end
end
