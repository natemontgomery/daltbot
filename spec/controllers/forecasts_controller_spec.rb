require 'rails_helper'

RSpec.describe ForecastsController do
  describe "#create" do
    it "creates an address from input and generates a forecast from OpenWeather API result" do
      VCR.use_cassette('geocoder/address-lookup') do
        VCR.use_cassette('open-weather/current') do
          expect do
            post :create, params: {forecast: {raw_address: '123 SE 4th St New York, NY'}}
          end.to change(Forecast, :count).by(1)
        end
      end

      forecast = assigns[:forecast]
      expect(forecast.address.raw_address).to eq('123 SE 4th St New York, NY')
      expect(forecast.temp).to eq(66.97)

      expect(assigns[:cached]).to eq(false)
    end

    context "when an address with a matching zip code has been searched in the last 30 minutes" do
      before do
        forecast = Forecast.create!(address: Address.create!(raw_address: 'foobar', postcode: '10036'), temp: 66.97)
        allow(Rails.cache).to receive(:fetch).with("10036/forecast-id", expires_in: 30.minutes).and_return(forecast.id)
      end

      it "uses the cached data" do
        VCR.use_cassette('geocoder/address-lookup') do
          expect do
            post :create, params: {forecast: {raw_address: '123 SE 4th St New York, NY'}}
          end.to change(Forecast, :count).by(0)
        end

        forecast = assigns[:forecast]
        expect(forecast.address.raw_address).to eq('foobar')
        expect(forecast.temp).to eq(66.97)

        expect(assigns[:cached]).to eq(true)
      end
    end
  end

  describe "#show" do
    it "sets cached boolean so we can display cached status" do
      forecast = Forecast.create!(address: Address.create!(raw_address: 'foobar', postcode: '10036'), temp: 66.97)
      get :show, params: {id: forecast.id}
      expect(assigns[:cached]).to eq(false)

      get :show, params: {id: forecast.id, cached: "true"}
      expect(assigns[:cached]).to eq(true)
    end
  end
end
