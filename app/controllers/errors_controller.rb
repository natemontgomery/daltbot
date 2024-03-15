class ErrorsController < ApplicationController
  def not_found
    respond_to do |format|
      format.json { render json: {}, status: :not_found }
      format.html { render 'errors/404', status: :not_found }
    end
  end

  def forbidden
    respond_to do |format|
      format.json { render json: {}, status: :forbidden }
      format.html { render 'errors/403', status: :forbidden }
    end
  end

  def internal_server_error
    respond_to do |format|
      format.json { render json: {}, status: :internal_server_error }
      format.html { render 'errors/500', status: :internal_server_error }
    end
  end
end
