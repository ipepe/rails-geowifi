class WifiObservationsImporter
  BATCH_SIZE = 2_000
  class OpenBMapDump < ActiveRecord::Base
    establish_connection(adapter: 'sqlite3', database: Rails.root.join('db', 'dumps', 'openbmap.sqlite'))
    self.abstract_class = true
  end
  class WifiZone < OpenBMapDump
    self.table_name = 'wifi_zone'
  end
  def self.import_openbmap
    query = WifiZone.where(
      latitude: Rails.application.warsaw_area[:latitude],
      longitude: Rails.application.warsaw_area[:longitude]
    )
    progressbar = ProgressBar.create(
      total: query.count/BATCH_SIZE,
      format: "%a %e %P% Processed: %c from %C"
    )
    query.in_batches(of: BATCH_SIZE) do |relation|
      progressbar.increment
      WifiObservation.import %i[bssid longitude latitude observed_at raw_info source id_of_source], (
        relation.map do |wifi_zone|
          [
            WifiObservation.standardize_bssid(wifi_zone.bssid),
            wifi_zone.longitude,
            wifi_zone.latitude,
            wifi_zone.last_updated,
            wifi_zone.attributes,
            'openbmap',
            wifi_zone.id
          ]
        end
      )
    end
  end

  def self.import_openwifi_su
    file_path = Rails.root.join('db', 'dumps', 'openwifi_su.csv')
    progressbar = ProgressBar.create(
      total: (`wc -l #{file_path}`.to_i-1)/BATCH_SIZE,
      format: "%a %e %P% Processed: %c from %C"
    )
    SmarterCSV.process(
      File.open(file_path),
      chunk_size: BATCH_SIZE,
      col_sep: '	',
      headers_in_file: true
    ) do |chunk|
      progressbar.increment
      WifiObservation.import %i[bssid longitude latitude raw_info source], (
        chunk.select do |wifi|
          Rails.application.warsaw_area[:latitude].cover?(wifi[:lat]) &&
            Rails.application.warsaw_area[:longitude].cover?(wifi[:lon])
        end.map do |row|
          [
            WifiObservation.standardize_bssid(row[:bssid]),
            row[:lon],
            row[:lat],
            row,
            'openwifi_su'
          ]
        end
      )
    end
  end

  def self.import_mylnikov
    # id,data_source,bssid,lat,lon,range,updated,created
    # 1155506572,-1,0037B78D708D,45.77844080,4.80769845,140.00,1469833291,1469833291
    # 'id' bigint(20) unsigned NOT NULL AUTO_INCREMENT,
    # 'bssid' varchar(12) NOT NULL,
    # 'signal' smallint(6) NOT NULL DEFAULT '-200',
    # 'lon' decimal(13,8) NOT NULL,
    # 'lat' decimal(13,8) NOT NULL,
    # 'updated' int(11) NOT NULL DEFAULT '1428513555',
    # 'created' int(11) NOT NULL DEFAULT '1428513555',
    # 'data' tinyint(4) NOT NULL DEFAULT '0',
    # 'range' decimal(6,2) NOT NULL DEFAULT '140.00',
    file_path = Rails.root.join('db', 'dumps', 'mylnikov.csv')
    progressbar = ProgressBar.create(
      total: (`wc -l #{file_path}`.to_i-1)/BATCH_SIZE,
      format: "%a %e %P% Processed: %c from %C"
    )
    SmarterCSV.process(
      File.open(file_path),
    chunk_size: BATCH_SIZE,
      col_sep: ',',
      headers_in_file: true
    ) do |chunk|
      progressbar.increment
      WifiObservation.import %i[bssid longitude latitude observed_at raw_info source id_of_source], (
        chunk.select do |wifi|
          Rails.application.warsaw_area[:latitude].cover?(wifi[:lat]) &&
          Rails.application.warsaw_area[:longitude].cover?(wifi[:lon])
        end.map do |row|
          [WifiObservation.standardize_bssid(row[:bssid]), row[:lon], row[:lat], DateTime.strptime(row[:updated].to_s, '%s'), row, 'mylnikov_org', row[:id]]
        end
      )
    end
  end
end
