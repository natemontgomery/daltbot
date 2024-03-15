class Forecast < ApplicationRecord
  belongs_to :address

  enum :forecast_type, [:current, :hourly, :daily]

  def fetch_current_weather
    OPEN_WEATHER_CLIENT.current_weather(lat: address.latitude, lon: address.longitude)
  end
end
