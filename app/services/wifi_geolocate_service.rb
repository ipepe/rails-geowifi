class WifiGeolocateService
  def self.query(params)
    return nil if params[:wifiAccessPoints].blank?
    #TODO: save all params for future reference?
    params[:wifiAccessPoints].sort_by { |ap| ap[:signalStrength] }.reverse.detect do |ap|
      if (observation = WifiObservation.
        where(bssid: WifiObservation.standardize_bssid(ap[:macAddress])).
        order(observed_at: :desc).
        first).present?

        return {
          "location": {
            "lat": observation.latitude,
            "lng": observation.longitude
          },
          "accuracy": observation.geolocation_accuracy
        }
      end
    end
  end
end