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
        "feels_like" => 65.48,
        "humidity" => 45,
        "pressure" => 1004,
        "temp" => 66.97,
        "temp_max" => 70.05,
        "temp_min" => 63.21,
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
end
