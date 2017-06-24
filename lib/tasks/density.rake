namespace :wifi do
  task measure_density: :environment do
    # pomiar gestosci
    distance = 0.5
    warsaw_spire_plac_europejski_1 = [52.232175,20.984187]
    losowy = [52.273075, 20.974593]
    zeromskiego_1 = [ 52.275371, 20.960779]


    puts [
      WifiPosition.within_bounding_box(Geocoder::Calculations.bounding_box(losowy, distance)).length,
      WifiPosition.within_bounding_box(Geocoder::Calculations.bounding_box(warsaw_spire_plac_europejski_1, distance)).length,
      WifiPosition.within_bounding_box(Geocoder::Calculations.bounding_box(zeromskiego_1, distance)).length
    ].inspect
  end
end
