class Forecast < ApplicationRecord
  belongs_to :address

  enum :forecast_type, [:current, :hourly, :daily]

  def fetch_current_weather
    weather_summary = OPEN_WEATHER_CLIENT.current_weather(lat: address.latitude, lon: address.longitude)
    assign_attributes(dt: weather_summary.dt, **weather_summary.main)
  end
end
