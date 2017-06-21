class WifiGeolocateService
  def self.query(params)
    return nil if params[:wifiAccessPoints].blank?
    #TODO: save all params for future reference?
    result = {
      "location": {
        "lat": nil,
        "lng": nil
      },
      "accuracy": 0,
      meta: []
    }.with_indifferent_access

    positions = WifiPosition.where(bssid: params[:wifiAccessPoints].map do |ap|
      WifiObservation.standardize_bssid(ap[:macAddress])
    end)

    if positions.present?
      result["location"]["lat"], result["location"]["lng"] = self.centroid_of(positions)
      result["accuracy"] = (Geocoder::Calculations.distance_between(
        [positions.map(&:latitude).max,positions.map(&:longitude).max],
        [positions.map(&:latitude).min,positions.map(&:longitude).min],
        units: :km
      )*1000)+30
    end
    result
  end

  def self.centroid_of(positions)
    if positions.size == 1
      return [positions.first.latitude,positions.first.longitude]
    else
      Geocoder::Calculations.geographic_center(positions.map(&:coordinates))
    end
  end
end