require 'rails_helper'

RSpec.describe ForecastsController do
  describe "#create" do
    it "creates an address from input" do
      VCR.use_cassette('geocoder/address-creation', allow_playback_repeats: true) do
        VCR.use_cassette('geocoder/address-lookup') do
          expect do
            post :create, params: {forecast: {raw_address: '123 SE 4th St New York, NY'}}
          end.to change(Forecast, :count).by(1)
        end
      end

      expect(assigns[:forecast].address.raw_address).to eq('123 SE 4th St New York, NY')
    end
  end

  describe "#show" do
    it "generates a forecast from OpenWeather API result" do
      VCR.use_cassette('geocoder/address-creation') do
        VCR.use_cassette('geocoder/address-lookup') do
          address = Address.create!(raw_address: '123 SE 4th St New York, NY')
          address.fill_in_address_attrs
          forecast = Forecast.create!(address: address)
          allow(Forecast).to receive(:find).with(forecast.id.to_s).and_return(forecast)

          VCR.use_cassette('open-weather/current') do
            expect(forecast).to receive(:fetch_current_weather).and_call_original
            get :show, params: {id: forecast.id}

            expect(assigns[:current_weather].main.temp).to eq(66.97)
          end
        end
      end
    end
  end
end
