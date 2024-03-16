class Address < ApplicationRecord
  has_many :forecasts

  geocoded_by :raw_address
  reverse_geocoded_by :latitude, :longitude

  # Fill in all our attributes from geocoded raw address string.
  def fill_in_address_attrs
    geocode
    reverse_geocoded_address = Geocoder.search([latitude, longitude]).first
    raise ActiveRecord::RecordNotFound if reverse_geocoded_address.blank?

    geocoded_address_attrs = reverse_geocoded_address.data["properties"].slice(
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

  # Create cache key off our geocoded Zip Code per requested design.
  def cache_key
    "#{postcode}/forecast-id"
  end
end
