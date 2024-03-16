class ForecastsController < ApplicationController
  def new
    @forecast = Forecast.new
  end

  def create
    if permitted_params[:raw_address].blank?
      @forecast = Forecast.new
      @forecast.errors.add(:base, "You gave me no address :(")
      render :new, status: :bad_request
      return
    end

    geocode_address

    # Check if we have a cached Forecast for the Zip Code of our Address.
    cached_forecast_id = Rails.cache.read(@address.cache_key)
    @cached = cached_forecast_id.present? # Tell the later output that we used a cached value.
    @forecast = cached_forecast_id.present? ? Forecast.find(cached_forecast_id) : Forecast.new(address: @address)
    @forecast.fetch_all_weather if cached_forecast_id.blank? # Only fetch weather if we are not using a cached result.

    if @forecast.save
      # If we did not have a cache create one, but only if we didn't have one.
      # If we did have a cached result we do not want to reset the expiration.
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
    @cached = params[:cached] == "true"
    @forecast = Forecast.find(params[:id])
  end

  protected

  def permitted_params
    params.require(:forecast).permit(:raw_address)
  end

  def geocode_address
    @address = Address.find_or_initialize_by(raw_address: permitted_params[:raw_address])

    unless @address.persisted?
      @address.fill_in_address_attrs
      @address.save!
    end
  end
end
