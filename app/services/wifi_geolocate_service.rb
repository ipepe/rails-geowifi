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
    }.with_indifferent_access
    positions = params[:wifiAccessPoints].sort_by { |ap| ap[:signalStrength] }.reverse.map do |ap|
      WifiPosition.find_by(bssid: WifiObservation.standardize_bssid(ap[:macAddress]))
    end.compact
    result["meta"] = positions.map(&:geojson_hash)
    if positions.present?
      result["location"]["lat"] = positions.map(&:latitude).sum / positions.size.to_f
      result["location"]["lng"] = positions.map(&:longitude).sum / positions.size.to_f
      result["accuracy"] = Geocoder::Calculations.distance_between(
        [positions.map(&:latitude).max,positions.map(&:longitude).max],
        [positions.map(&:latitude).min,positions.map(&:longitude).min],
        units: :km
      )*750
    end
    result
  end
end