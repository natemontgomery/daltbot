OpenWeather::Client.configure do |config|
  config.api_key = ENV["API_KEY"]
  config.units = 'imperial'
end

# Store our OpenWeather client in a constant so we always have access to the API without
# needing to instantiate multiple instances.
OPEN_WEATHER_CLIENT = OpenWeather::Client.new
