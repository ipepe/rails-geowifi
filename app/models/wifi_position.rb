class WifiPosition < ApplicationRecord

  reverse_geocoded_by :latitude, :longitude

  scope :for_area, -> (latitude: 52.23, logitude: 21.01, radius: 20, limit: 10_000) do
    near([latitude, logitude], radius).limit(limit)
  end

  def readonly?
    true
  end

  def self.geojson_array
    "["+(self.to_a.map(&:geojson).join(','))+"]"
  end

  def geojson_hash
    JSON.parse(self.geojson)
  end

  def coordinates
    [latitude, longitude]
  end
end