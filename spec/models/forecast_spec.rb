require 'rails_helper'

RSpec.describe Forecast do
  describe '#fetch_current_weather' do
    it 'returns the current weather' do
      forecast = nil

      VCR.use_cassette('geocoder/address-creation') do
        VCR.use_cassette('geocoder/address-lookup') do
          address = Address.create!(raw_address: '123 SE 4th St New York, NY')
          address.fill_in_address_attrs
          forecast = described_class.create!(address: address)
        end
      end

      VCR.use_cassette('open-weather/current') do
        expect(forecast.fetch_current_weather).to match(
          "base" => "stations",
          "clouds" => {"all"=>75},
          "cod" => 200,
          "coord" => {"lat"=>40.7648, "lon"=>-73.9808},
          "dt" => Time.zone.parse("2024-03-15 20:28:25"),
          "id" => 5125771,
          "main" => {"feels_like"=>65.48, "humidity"=>45, "pressure"=>1004, "temp"=>66.97, "temp_max"=>70.05, "temp_min"=>63.21},
          "name" => "Manhattan",
          "sys" => {
            "country"=>"US",
            "id"=>5141,
            "sunrise"=>Time.zone.parse("2024-03-15 11:06:51"),
            "sunset"=>Time.zone.parse("2024-03-15 23:02:38"),
            "type"=>1
          },
          "timezone" => -14400,
          "visibility" => 10000,
          "weather" => [{"description"=>"broken clouds", "icon"=>"04d", "icon_uri"=>anything, "id"=>803, "main"=>"Clouds"}],
          "wind" => {"deg"=>300, "speed"=>20.71}
        )
      end
    end
  end
end
