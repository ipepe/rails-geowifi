class CreateWifiObservations < ActiveRecord::Migration
  def change
    create_table :wifi_observations do |t|
      t.string :bssid, null: false, index: true
      t.float :latitude, null: false, index: true
      t.float :longitude, null: false, index: true
      t.string :source, default: 'internal', null: false, index: true
      t.json :raw_info
      t.datetime :observed_at, index: true

      t.timestamps
    end

  end
end
