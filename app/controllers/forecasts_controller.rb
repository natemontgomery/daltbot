class ForecastsController < ApplicationController
  def new
    @forecast = Forecast.new
  end

  def create
    geocode_address
    @forecast = Forecast.new(address: @address)
    binding.b
    if @forecast.save
      redirect_to forecast_url(@forecast)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @forecast = Forecast.find(permitted_params[:id])
  end

  protected

  def permitted_params
    params.permit(:id, forecast: :raw_address)
  end

  def geocode_address
    @address = Address.find_or_initialize_by(raw_address: permitted_params[:forecast][:raw_address])
    binding.b
    @address.fill_in_address_fields
    @address.save!
  end
end
