# Use Photon free geocoder API, limit to 1 result since we are just looking up an address to pass to Weather API.
Geocoder.configure(
  use_https: true,
  lookup: :photon,
  limit: 1,
  cache: Rails.cache
)
