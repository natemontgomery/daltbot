require 'rails_helper'

RSpec.describe ForecastsController do
  describe "#create" do
    it "creates an address from input and generates a forecast from OpenWeather API result" do
      VCR.use_cassette('geocoder/address-lookup') do
        VCR.use_cassette('open-weather/current') do
          VCR.use_cassette('open-weather/5-day-forecast') do
            expect do
              post :create, params: {forecast: {raw_address: '123 SE 4th St New York, NY'}}
            end.to change(Forecast, :count).by(1)
          end
        end
      end

      forecast = assigns[:forecast]
      expect(forecast.address.raw_address).to eq('123 SE 4th St New York, NY')
      expect(forecast.temp).to eq(46.53)

      expect(assigns[:cached]).to eq(false)
    end

    context "when an address with a matching zip code has been searched in the last 30 minutes" do
      before do
        forecast = Forecast.create!(address: Address.create!(raw_address: 'foobar', postcode: '10036'), temp: 66.97)

        # We have to account for Geocoder caching.
        allow(Rails.cache).to receive(:read).and_call_original

        # Store our cache key to check behavior in test.
        allow(Rails.cache).to receive(:read).with("10036/forecast-id").and_return(forecast.id)
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
