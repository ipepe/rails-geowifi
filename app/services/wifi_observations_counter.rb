class WifiObservationsCounter
  BATCH_SIZE = 2_000
  class OpenBMapDump < ActiveRecord::Base
    establish_connection(adapter: 'sqlite3', database: Rails.root.join('db', 'dumps', 'openbmap.sqlite'))
    self.abstract_class = true
  end
  class WifiZone < OpenBMapDump
    self.table_name = 'wifi_zone'
  end
  def self.count_openbmap
    query = WifiZone.where(
      latitude: Rails.application.warsaw_area[:latitude],
      longitude: Rails.application.warsaw_area[:longitude]
    )
    puts "#{query.count}/#{WifiZone.count}"
  end

  def self.count_openwifi_su
    file_path = Rails.root.join('db', 'dumps', 'openwifi_su.csv')
    progressbar = ProgressBar.create(
      total: (`wc -l #{file_path}`.to_i-1)/BATCH_SIZE,
      format: "%a %e %P% Processed: %c from %C"
    )
    counter = 0
    SmarterCSV.process(
      File.open(file_path),
      chunk_size: BATCH_SIZE,
      col_sep: '	',
      headers_in_file: true
    ) do |chunk|
      progressbar.increment
      counter += chunk.select do |wifi|
        Rails.application.warsaw_area[:latitude].cover?(wifi[:lat]) &&
          Rails.application.warsaw_area[:longitude].cover?(wifi[:lon])
      end.size
    end
    puts "#{counter}/"+`wc -l #{file_path}`
  end

  def self.count_mylnikov
    file_path = Rails.root.join('db', 'dumps', 'mylnikov.csv')
    progressbar = ProgressBar.create(
      total: (`wc -l #{file_path}`.to_i-1)/BATCH_SIZE,
      format: "%a %e %P% Processed: %c from %C"
    )
    counter = 0
    SmarterCSV.process(
      File.open(file_path),
    chunk_size: BATCH_SIZE,
      col_sep: ',',
      headers_in_file: true
    ) do |chunk|
      progressbar.increment
      counter += chunk.select do |wifi|
        Rails.application.warsaw_area[:latitude].cover?(wifi[:lat]) &&
        Rails.application.warsaw_area[:longitude].cover?(wifi[:lon])
      end.size
    end
    puts "#{counter}/"+`wc -l #{file_path}`
  end
end
