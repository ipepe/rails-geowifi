namespace :wifis do
  task import_mylnikov: :environment do
    puts 'Importing wifis'
    puts(Benchmark.measure do
      WifiObservationsImporter.import_mylnikov
    end)
  end

  task import_openwifi_su: :environment do
    start_time = Time.current
    puts "Started mylnikov import at #{start_time}"
    WifiObservationsImporter.import_openwifi_su
    puts "Time elapsed = #{Time.current - start_time}s"
  end

  task import_radiocells: :environment do
    start_time = Time.current
    puts "Started mylnikov import at #{start_time}"
    WifiObservationsImporter.import_radiocells
    puts "Time elapsed = #{Time.current - start_time}s"
  end

  task import_all: %i[import_mylnikov import_openwifi_su import_radiocells]
end
