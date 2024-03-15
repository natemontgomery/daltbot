class ForecastsController < ApplicationController
  def new
    @forecast = Forecast.new
  end

  def create
    geocode_address

    # Create cache key off our geocoded Zip Code per requested design.
    cache_key = "#{@address.postcode}/forecast-id"
    cached_forecast_id = Rails.cache.read(cache_key)
    @cached = cached_forecast_id.present? # Tell the later output that we used a cached value.

    @forecast = cached_forecast_id.present? ? Forecast.find(cached_forecast_id) : Forecast.new(address: @address)
    @forecast.fetch_current_weather if cached_forecast_id.blank?

    if @forecast.save
      # If we did not have a cache create one, but only if we didn't have one.
      # If we did have a cached we do not want to reset the expiration.
      if @cached.blank?
        Rails.cache.fetch("#{@address.postcode}/forecast-id", expires_in: 30.minutes) do
          @forecast.id
        end
      end

      redirect_to "#{forecast_url(@forecast)}?cached=#{@cached}"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @cached = permitted_params[:cached] == "true"
    @forecast = Forecast.find(permitted_params[:id])
  end

  protected

  def permitted_params
    params.permit(:id, :cached, forecast: :raw_address)
  end

  def geocode_address
    @address = Address.find_or_initialize_by(raw_address: permitted_params[:forecast][:raw_address])
    @address.fill_in_address_attrs
    @address.save!
  end
end
