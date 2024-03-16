# Use Photon free geocoder API, limit to 1 result since we are just looking up an address to pass to Weather API.
# Turns on caching so we avoid repeated calls to geocode the same address.
Geocoder.configure(
  use_https: true,
  lookup: :photon,
  limit: 1,
  cache: Rails.cache
)
