# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150225225003) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: true do |t|
    t.string   "street_address"
    t.string   "apartment"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "zip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "names", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "middle_name"
    t.string   "suffix"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "va_ballot_requests", force: true do |t|
    t.integer  "name_id"
    t.integer  "current_address_id"
    t.integer  "registered_address_id"
    t.string   "ssn_four"
    t.string   "reason_code"
    t.string   "reason_support"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "va_ballot_requests", ["name_id"], name: "index_va_ballot_requests_on_name_id", using: :btree

end
