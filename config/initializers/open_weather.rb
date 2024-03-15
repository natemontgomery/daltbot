OpenWeather::Client.configure do |config|
  config.api_key = ENV["API_KEY"]
  config.units = 'imperial'
end

OPEN_WEATHER_CLIENT = OpenWeather::Client.new
