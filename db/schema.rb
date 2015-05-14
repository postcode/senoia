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

ActiveRecord::Schema.define(version: 20150514173124) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "dispatches", force: :cascade do |t|
    t.string   "name"
    t.string   "level"
    t.integer  "provider_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "dispatchs_users", force: :cascade do |t|
    t.integer "dispatch_id"
    t.integer "user_id"
    t.boolean "contact"
  end

  create_table "event_types", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "first_aid_stations", force: :cascade do |t|
    t.string   "name"
    t.integer  "md"
    t.integer  "rn"
    t.integer  "emt"
    t.integer  "aed"
    t.string   "level"
    t.integer  "provider_id"
    t.decimal  "lat",         precision: 10, scale: 6
    t.decimal  "lng",         precision: 10, scale: 6
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  create_table "first_aid_stations_users", force: :cascade do |t|
    t.integer "first_aid_staion_id"
    t.integer "user_id"
    t.boolean "contact"
  end

  create_table "medical_assets", force: :cascade do |t|
    t.integer  "asset_id"
    t.integer  "operational_period_id"
    t.integer  "user_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "mobile_teams", force: :cascade do |t|
    t.string   "level"
    t.string   "type"
    t.integer  "aed"
    t.integer  "provider_id"
    t.string   "name"
    t.decimal  "lat",         precision: 10, scale: 6
    t.decimal  "lng",         precision: 10, scale: 6
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  create_table "mobile_teams_users", force: :cascade do |t|
    t.integer "mobile_team_id"
    t.integer "user_id"
    t.boolean "contact"
  end

  create_table "operation_periods", force: :cascade do |t|
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer  "attendance"
    t.integer  "plan_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "permitters", force: :cascade do |t|
    t.string   "name"
    t.string   "phone_number"
    t.text     "address"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "permitters_users", force: :cascade do |t|
    t.integer "permitter_id"
    t.integer "user_id"
    t.boolean "contact"
  end

  create_table "plans", force: :cascade do |t|
    t.string   "name"
    t.integer  "owner_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer  "attendance"
    t.boolean  "alcohol"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "event_type_id"
    t.integer  "permitter_id"
  end

  create_table "providers", force: :cascade do |t|
    t.string   "name"
    t.string   "phone_number"
    t.text     "address"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "providers_users", force: :cascade do |t|
    t.integer "provider_id"
    t.integer "user_id"
    t.boolean "contact"
  end

  create_table "transports", force: :cascade do |t|
    t.string   "name"
    t.string   "level"
    t.integer  "provider_id"
    t.decimal  "lat",         precision: 10, scale: 6
    t.decimal  "lng",         precision: 10, scale: 6
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  create_table "transports_users", force: :cascade do |t|
    t.integer "transport_id"
    t.integer "user_id"
    t.boolean "contact"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",      null: false
    t.string   "encrypted_password",     default: "",      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "role",                   default: "guest", null: false
    t.integer  "organization_id"
    t.string   "phone_number"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
