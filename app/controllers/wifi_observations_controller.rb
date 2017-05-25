class WifiObservationsController < ApplicationController
  def index
    respond_to do |format|
      format.html { head 404 }
      format.geojson { render json: JSON[WifiObservation.limit(50_000).pluck_geojson] }
    end
  end
end
