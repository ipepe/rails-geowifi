class WifiObservation < ApplicationRecord
  INTERNAL_SOURCES = %w[internal mylnikov_org openbmap openwifi_su]
  validates :bssid, :latitude, :longitude, :source, presence: true

  def geojson_hash
    {
      type: 'Feature',
      geometry: {
        type: 'Point',
        coordinates: geojson_coordinates
      },
      properties: {
        id: id,
        bssid: bssid
      }
    }
  end

  def geolocation_accuracy
    raw_info['geolocation_accuracy'] || 120
  end

  def geojson_coordinates
    [longitude, latitude]
  end

  def delimetered_bssid
    bssid.to_s.scan(/.{2}/).join(':')
  end

  def bssid
    self.class.standardize_bssid(self.read_attribute(:bssid))
  end

  def self.standardize_bssid(value)
    # 00:0A:E6:3E:FD:E1
    result = value.to_s.upcase.gsub(/[^A-F0-9]/, '')
    return nil if result.size != 12
    result
  end
end
