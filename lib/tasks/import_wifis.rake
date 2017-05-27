namespace :wifi do
  task import_mylnikov: :environment do
    puts 'Importing mylnikov'
    puts(Benchmark.measure do
      WifiObservationsImporter.import_mylnikov
    end)
  end

  task import_openwifi_su: :environment do
    puts 'Importing openwifi_su'
    puts(Benchmark.measure do
      WifiObservationsImporter.import_openwifi_su
    end)
  end

  task import_openbmap: :environment do
    puts 'Importing openbmap'
    puts(Benchmark.measure do
      WifiObservationsImporter.import_openbmap
    end)
  end

  task import_all: %i[import_mylnikov import_openwifi_su import_openbmap]
end
