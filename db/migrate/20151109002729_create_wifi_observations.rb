class CreateWifiObservations < ActiveRecord::Migration
  def change
    create_table :wifi_observations do |t|
      t.string :bssid, null: false, index: true
      t.string :ssid, index: true
      t.datetime :observed_at

      t.float :latitude, null: false, index: true
      t.float :longitude, null: false, index: true
      t.datetime :geolocated_at

      t.string :source, default: 'internal', null: false
      t.string :id_of_source

      t.boolean :is_received, default: false, null: false

      t.json :raw_info

      t.timestamps
    end

    add_index :wifi_observations, [:source, :id_of_source], unique: true

  end
end
