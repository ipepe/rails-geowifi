class WifiObservation < ApplicationRecord
  INTERNAL_SOURCES = %w[internal mylnikov_org openbmap openwifi_su]
  validates :bssid, :latitude, :longitude, :source, presence: true

  # def self.default_scope
  #   where("bssid NOT IN (SELECT bssid FROM wifi_observations WHERE ssid ILIKE '%_nomap%' OR ssid ILIKE '%_optout%')")
  # end

  # if Rails.env.development?
  #   validates :latitude, numericality: { in: Rails.application.warsaw_area[:latitude] }
  #   validates :longitude, numericality: { in: Rails.application.warsaw_area[:longitude] }
  # end

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
      )::text AS geojson
    SQL
  end

  def self.geojson_array
    "["+(Parallel.map(self.pluck(:id, :bssid, :longitude, :latitude), in_processes: 1, in_threads: 2) do |id, bssid, lon, lat|
      <<-JSON
{"type":"Feature","geometry":{"type":"Point","coordinates":[#{lon}, #{lat}]},"properties":{"id":#{id},"bssid":"#{bssid}"}}
      JSON
    end.join(','))+"]"
  end

  # def self.bm
  #   ActiveRecord::Base.logger = nil
  #   Benchmark.bmbm do |b|
  #     b.report('JSON[pluck_geojson]') { 5.times { JSON[WifiObservation.pluck(:longitude, :latitude, :bssid)] }}
  #     b.report('OJ.dump(pluck_geojson)') { 5.times { Oj.dump(WifiObservation.limit(50_000).pluck_geojson) }}
  #     b.report('JSON[pluck_geojson]') { 5.times { JSON[WifiObservation.limit(50_000).pluck_geojson] }}
  #     b.report('JSON.dump(pluck_geojson)') { 5.times { JSON.dump(WifiObservation.limit(50_000).pluck_geojson) }}
  #     b.report('JSON.generate(pluck_geojson)') { 5.times { JSON.generate(WifiObservation.limit(50_000).pluck_geojson) }}
  #     b.report('JSON.fast_generate(pluck_geojson)') { 5.times { JSON.fast_generate(WifiObservation.limit(50_000).pluck_geojson) }}
  #     b.report('pluck_geojson.to_json') { 5.times {  WifiObservation.limit(50_000).pluck_geojson.to_json }}
  #     b.report('JSON[map(&:geojson_hash)]') { 5.times {  JSON[WifiObservation.limit(50_000).map(&:geojson_hash)] }}
  #     b.report('map(&:geojson_hash).to_json') { 5.times {  WifiObservation.limit(50_000).map(&:geojson_hash).to_json }}
  #   end
  # end

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
