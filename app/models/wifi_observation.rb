class WifiObservation < ApplicationRecord
  enum_with_string_values source: %i[internal mylnikov_org openwifi_su radiocells_org]
  validates :bssid, :latitude, :longitude, :source, presence: true
  validates :latitude, numericality: { in: Rails.application.warsaw_area[:latitude] }
  validates :longitude, numericality: { in: Rails.application.warsaw_area[:longitude] }

  def self.pluck_geojson
    pluck <<-SQL.strip_heredoc
      json_build_object(
        'type', 'Feature',
        'geometry', json_build_object(
          'type', 'Point',
          'coordinates', json_build_array(
            longitude,latitude
          )
        ),
        'properties', json_build_object(
          'id', id,
          'bssid', bssid
        )
      ) AS geojson
    SQL
  end

  def self.bm
    ActiveRecord::Base.logger = nil
    Benchmark.bm do |b|
      b.report('JSON[pluck_geojson]') { 5.times { JSON[WifiObservation.limit(50_000).pluck_geojson] }}
      b.report('pluck_geojson.to_json') { 5.times {  WifiObservation.limit(50_000).pluck_geojson.to_json }}
      b.report('JSON[map(&:geojson_hash)]') { 5.times {  JSON[WifiObservation.limit(50_000).map(&:geojson_hash)] }}
      b.report('map(&:geojson_hash).to_json') { 5.times {  WifiObservation.limit(50_000).map(&:geojson_hash).to_json }}
    end
  end

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

  def geojson_coordinates
    [longitude, latitude]
  end

  def delimetered_bssid
    bssid.to_s.scan(/.{2}/).join(':')
  end

  def self.standardize_bssid(value)
    # 00:0A:E6:3E:FD:E1
    result = value.to_s.upcase.gsub(/[^A-F0-9]/, '')
    return nil if result.size != 12
    result
  end
end
