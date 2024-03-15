class Address < ApplicationRecord
  has_many :forecasts

  geocoded_by :raw_address
  reverse_geocoded_by :latitude, :longitude

  # Fill in all our attributes from geocoded raw address string.
  def fill_in_address_attrs
    geocode
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
    "#{housenumber} #{street} #{city}, #{state} #{postcode}"
  end
end
