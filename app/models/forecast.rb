class Forecast < ApplicationRecord
  belongs_to :address

  # Main interface to gather OpenWeather data into our model.
  def fetch_all_weather
    fetch_current_weather
    fetch_5_day_weather
  end

  # Current weather as provided by the OpenWeb client gem.
  def fetch_current_weather
    weather_summary = OPEN_WEATHER_CLIENT.current_weather(lat: address.latitude, lon: address.longitude)
    assign_attributes(
      dt: weather_summary.dt,
      weather_description: weather_summary.weather.first.description,
      **weather_summary.main
    )
  end

  # We do not get to use the One Call API for free, so this uses a free API for our multiday weather forecast.
  # The client gem does not implement this inteface so we don't get the nice client based models but we can use JSON just fine.
  def fetch_5_day_weather
    assign_attributes(
      raw_forecast: OPEN_WEATHER_CLIENT.get('2.5/forecast', {lat: address.latitude, lon: address.longitude})
    )
  end

  # Turn our JSON blob into an Array of hashes that align with the model provided attributes from the client gem.
  def parsed_forecast_datapoints
    raw_forecast["list"].map do |weather_hash|
     {
        dt: weather_hash["dt"],
        weather_description: weather_hash["weather"].first["description"],
        **weather_hash["main"]
      }
    end
  end
end
