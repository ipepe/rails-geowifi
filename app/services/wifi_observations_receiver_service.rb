class WifiObservationsReceiverService
  def self.import(params)
    source = params[:meta][:source] || "unknown_#{SecureRandom.uuid}"
    if WifiObservation::INTERNAL_SOURCES.any? {|n| source.downcase.include?(n)}
      raise ActiveRecord::RecordNotSaved.new("Internal source names are reserved")
    end
    WifiObservation.import(%i[bssid ssid longitude latitude observed_at raw_info source id_of_source], (
    params[:wifi_observations].map do |wifi|
      [WifiObservation.standardize_bssid(wifi[:bssid]), wifi[:ssid], wifi[:longitude], wifi[:latitude], wifi[:observed_at], wifi.to_h, source, wifi[:id]]
    end
    ))
  end
end