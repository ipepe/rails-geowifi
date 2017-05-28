class Api::V1::GeolocatesController < ApplicationController
  protect_from_forgery except: :create

  def create
    render json: JSON[WifiGeolocateService.query(params_for_create)]
  end

  private

  def params_for_create
    params.permit!
  end
end