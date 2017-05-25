class WifiObservationsImporter
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

    SmarterCSV.process(
      File.open(Rails.root.join('db', 'dumps', 'mylnikov.csv')),
      chunk_size: 2_000,
      col_sep: ',',
      headers_in_file: true
    ) do |chunk|
      WifiObservation.import(%i[bssid longitude latitude observed_at raw_info source], (chunk.map do |row|
        [WifiObservation.standardize_bssid(row[:bssid]), row[:lon], row[:lat], DateTime.strptime(row[:updated].to_s, '%s'), row.to_json, 'mylnikov_org']
      end))
    end
  end
end
