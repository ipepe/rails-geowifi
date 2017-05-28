class WifiGeolocateService
  def self.query(params)
    return nil if params[:wifiAccessPoints].blank?
    #TODO: save all params for future reference?
    result = {
      "location": {
        "lat": nil,
        "lng": nil
      },
      "accuracy": nil,
      meta: []
    }
    params[:wifiAccessPoints].sort_by { |ap| ap[:signalStrength] }.reverse.each do |ap|
      if (observation = WifiObservation.
        where(bssid: WifiObservation.standardize_bssid(ap[:macAddress])).
        order(observed_at: :desc).
        first).present?
        if result["accuracy"].blank?
          result["location"]["lat"] ||= observation.latitude
          result["location"]["lng"] ||= observation.longitude
          result["accuracy"] ||= observation.geolocation_accuracy
        end
        result["meta"].push(observation.geojson_hash)
      end
    end
    result
  end
end