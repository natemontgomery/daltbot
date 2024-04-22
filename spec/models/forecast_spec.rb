require 'rails_helper'

RSpec.describe Forecast do
  describe '#fetch_current_weather' do
    it 'returns the current weather' do
      forecast = nil

      VCR.use_cassette('geocoder/address-lookup') do
        address = Address.create!(raw_address: '123 SE 4th St New York, NY')
        address.fill_in_address_attrs
        forecast = described_class.create!(address: address)
      end

      VCR.use_cassette('open-weather/current') do
        forecast.fetch_current_weather
      end

      expect(forecast).to have_attributes(
        "feels_like" => 42.53,
        "humidity" => 48.0,
        "pressure" => 1016.0,
        "temp" => 46.53,
        "temp_max" => 46.53,
        "temp_min" => 46.53,
        "grnd_level" => 1014,
        "sea_level" => 1016,
        "weather_description" => "broken clouds"
      )
    end
  end

  describe '#fetch_5_day_weather' do
    it 'returns a 5 day forecast, stored in JSON for now' do
      forecast = nil

      VCR.use_cassette('geocoder/address-lookup') do
        address = Address.create!(raw_address: '123 SE 4th St New York, NY')
        address.fill_in_address_attrs
        forecast = described_class.create!(address: address)
      end

      VCR.use_cassette('open-weather/5-day-forecast') do
        forecast.fetch_5_day_weather
      end

      expect(forecast.raw_forecast["city"]["coord"]["lat"]).to eq(40.756)
    end
  end

  describe '#slice_weather_attributes' do
    it 'returns attributes for Forecast model and logs any attributes it does not recognise' do
      weather_source = {
        "feels_like" => 42.53,
        "humidity" => 48.0,
        "pressure" => 1016.0,
        "temp" => 46.53,
        "temp_max" => 46.53,
        "temp_min" => 46.53,
        "foobar" => "baz",
        "weather_description" => "broken clouds"
      }

      expect(Rails.logger).to receive(:info).with("NEW WEATHER ATTRIBUTES FOUND:\n\n[\"foobar\"]\n\n")
      expect(described_class.new.slice_weather_attributes(weather_source)).to eq(weather_source.except("foobar"))
    end
  end
end
