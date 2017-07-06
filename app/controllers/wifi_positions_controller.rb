class WifiPositionsController < ApplicationController
  def index
    respond_to do |format|
      format.html { head 404 }
      format.geojson { render json: "["+(WifiPosition.for_area(sanitize_index_params).map(&:geojson).join(','))+"]" }
    end
  end

  def show
    @wifi_observations = WifiObservation.where(bssid: params[:id])
  end

  private

  def sanitize_index_params
    {
      latitude: if params['center_latitude'].present? then params['center_latitude'].to_f else 52.23 end,
      logitude: if params['center_longitude'].present? then params['center_longitude'].to_f else 21.01 end,
      radius: if params['radius'].present? then params['radius'].to_f else 30 end,
      limit: if params['limit'].present? then params['limit'].to_i else 10_000 end
    }
  end
end
