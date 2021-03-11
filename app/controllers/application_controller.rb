class ApplicationController < ActionController::API
  include ExceptionHandler
  include ResponseHelper

  def index
    render :status => :ok, :json => {:app => "Nearby-API"}
  end

end
