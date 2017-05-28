class WifiObservationsController < ApplicationController
  def index
    respond_to do |format|
      format.html { head 404 }
      format.geojson { render json: WifiObservation.limit(25_000).geojson_array }
    end
  end
end
