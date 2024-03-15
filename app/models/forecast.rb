class Forecast < ApplicationRecord
  belongs_to :address

  def fetch_current_weather
    OPEN_WEATHER_CLIENT.current_weather(city: address.city)
  end
end
