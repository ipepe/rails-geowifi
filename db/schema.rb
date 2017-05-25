# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151109002729) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "wifi_observations", force: :cascade do |t|
    t.string   "bssid",                            null: false
    t.float    "latitude",                         null: false
    t.float    "longitude",                        null: false
    t.string   "source",      default: "internal", null: false
    t.json     "raw_info"
    t.datetime "observed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["bssid"], name: "index_wifi_observations_on_bssid", using: :btree
    t.index ["latitude"], name: "index_wifi_observations_on_latitude", using: :btree
    t.index ["longitude"], name: "index_wifi_observations_on_longitude", using: :btree
    t.index ["observed_at"], name: "index_wifi_observations_on_observed_at", using: :btree
    t.index ["source"], name: "index_wifi_observations_on_source", using: :btree
  end

end
