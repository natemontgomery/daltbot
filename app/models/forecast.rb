class Forecast < ApplicationRecord
  belongs_to :address

  def fetch_current_weather
    weather_summary = OPEN_WEATHER_CLIENT.current_weather(lat: address.latitude, lon: address.longitude)
    assign_attributes(
      dt: weather_summary.dt,
      weather_description: weather_summary.weather.first.description,
      **weather_summary.main
    )
  end
end
