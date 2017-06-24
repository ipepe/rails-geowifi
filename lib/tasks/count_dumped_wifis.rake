namespace :wifi do
  task count_mylnikov: :environment do
    puts 'Counting mylnikov'
    puts(Benchmark.measure do
      WifiObservationsCounter.count_mylnikov
    end)
  end

  task count_openwifi_su: :environment do
    puts 'Counting openwifi_su'
    puts(Benchmark.measure do
      WifiObservationsCounter.count_openwifi_su
    end)
  end

  task count_openbmap: :environment do
    puts 'Counting openbmap'
    puts(Benchmark.measure do
      WifiObservationsCounter.count_openbmap
    end)
  end

  task count_all: %i[count_mylnikov count_openwifi_su count_openbmap]
end
