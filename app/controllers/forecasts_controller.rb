class ForecastsController < ApplicationController
  def new
    @forecast = Forecast.new
  end

  def create
    @forecast = Forecast.new

    if @forecast.save
      redirect_to forecast_url(@forecast)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @forecast = Forecast.find(params[:id])
  end

  def current
  end

  def hourly
  end

  def daily
  end

  protected

  def geocode
    address = Address.find_or_initialize_by(raw_address: params[:address])
    address.save!
  end
end
