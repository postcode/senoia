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

ActiveRecord::Schema.define(version: 20161006190519) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "asset_communications", force: :cascade do |t|
    t.integer "asset_id"
    t.integer "communication_id"
    t.text    "description"
    t.integer "dispatch_id"
    t.integer "first_aid_station_id"
    t.integer "mobile_team_id"
    t.integer "transport_id"
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.string   "title"
    t.text     "body"
    t.string   "subject"
    t.integer  "user_id",                         null: false
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "element_id"
    t.boolean  "open",             default: true
  end

  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "communication_plans", force: :cascade do |t|
    t.string   "event_coordinator_name"
    t.string   "event_coordinator_phone"
    t.string   "event_coordinator_email"
    t.string   "event_coordinator_organization"
    t.string   "event_supervisor_name"
    t.string   "event_supervisor_phone"
    t.string   "event_supervisor_email"
    t.string   "event_supervisor_organization"
    t.string   "dispatch_supervisor_name"
    t.string   "dispatch_supervisor_phone"
    t.string   "dispatch_supervisor_email"
    t.string   "dispatch_supervisor_organization"
    t.string   "medical_group_supervisor_name"
    t.string   "medical_group_supervisor_phone"
    t.string   "medical_group_supervisor_email"
    t.string   "medical_group_supervisor_organization"
    t.string   "triage_supervisor_name"
    t.string   "triage_supervisor_phone"
    t.string   "triage_supervisor_email"
    t.string   "triage_supervisor_organization"
    t.string   "transport_supervisor_name"
    t.string   "transport_supervisor_email"
    t.string   "transport_supervisor_phone"
    t.string   "transport_supervisor_organization"
    t.string   "non_transport_supervisor_name"
    t.string   "non_transport_supervisor_email"
    t.string   "non_transport_supervisor_phone"
    t.string   "non_transport_supervisor_organization"
    t.integer  "plan_id"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  create_table "communications", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dispatches", force: :cascade do |t|
    t.string   "name"
    t.string   "level"
    t.integer  "organization_id"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.integer  "operation_period_id"
    t.string   "contact_name"
    t.string   "contact_phone"
    t.text     "location"
    t.decimal  "lat",                    precision: 10, scale: 6
    t.decimal  "lng",                    precision: 10, scale: 6
    t.text     "service_area"
    t.string   "planning_contact_email"
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
    t.integer  "organization_id"
    t.decimal  "lat",                    precision: 10, scale: 6
    t.decimal  "lng",                    precision: 10, scale: 6
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.integer  "operation_period_id"
    t.string   "contact_name"
    t.string   "contact_phone"
    t.text     "location"
    t.text     "service_area"
    t.string   "planning_contact_email"
  end

  create_table "first_aid_stations_users", force: :cascade do |t|
    t.integer "first_aid_staion_id"
    t.integer "user_id"
    t.boolean "contact"
  end

  create_table "impressions", force: :cascade do |t|
    t.string   "impressionable_type"
    t.integer  "impressionable_id"
    t.integer  "user_id"
    t.string   "controller_name"
    t.string   "action_name"
    t.string   "view_name"
    t.string   "request_hash"
    t.string   "ip_address"
    t.string   "session_hash"
    t.text     "message"
    t.text     "referrer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "impressions", ["controller_name", "action_name", "ip_address"], name: "controlleraction_ip_index", using: :btree
  add_index "impressions", ["controller_name", "action_name", "request_hash"], name: "controlleraction_request_index", using: :btree
  add_index "impressions", ["controller_name", "action_name", "session_hash"], name: "controlleraction_session_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "ip_address"], name: "poly_ip_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "request_hash"], name: "poly_request_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "session_hash"], name: "poly_session_index", using: :btree
  add_index "impressions", ["impressionable_type", "message", "impressionable_id"], name: "impressionable_type_message_index", using: :btree
  add_index "impressions", ["user_id"], name: "index_impressions_on_user_id", using: :btree

  create_table "invitations", force: :cascade do |t|
    t.integer  "plan_id"
    t.text     "email"
    t.string   "role"
    t.integer  "invited_user_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
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
    t.integer  "aed"
    t.integer  "organization_id"
    t.string   "name"
    t.decimal  "lat",                    precision: 10, scale: 6
    t.decimal  "lng",                    precision: 10, scale: 6
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.integer  "operation_period_id"
    t.string   "contact_name"
    t.string   "contact_phone"
    t.text     "location"
    t.string   "mobile_team_type"
    t.text     "service_area"
    t.string   "planning_contact_email"
  end

  create_table "mobile_teams_users", force: :cascade do |t|
    t.integer "mobile_team_id"
    t.integer "user_id"
    t.boolean "contact"
  end

  create_table "notification_group_memberships", force: :cascade do |t|
    t.integer  "notification_group_id"
    t.integer  "user_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "notification_group_memberships", ["notification_group_id", "user_id"], name: "index_notification_group_memberships_on_ng_id_and_user_id", unique: true, using: :btree
  add_index "notification_group_memberships", ["notification_group_id"], name: "index_notification_group_memberships_on_notification_group_id", using: :btree
  add_index "notification_group_memberships", ["user_id"], name: "index_notification_group_memberships_on_user_id", using: :btree

  create_table "notification_groups", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "notification_type"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.integer  "subject_id"
    t.string   "subject_type"
    t.text     "key"
    t.integer  "owner_id"
    t.boolean  "read",         default: false, null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "operation_periods", force: :cascade do |t|
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer  "attendance"
    t.integer  "plan_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "patients_treated_count"
    t.integer  "patients_transported_count"
    t.datetime "start_time"
    t.datetime "end_time"
    t.text     "service_area"
    t.string   "crowd_estimate"
    t.text     "location"
  end

  create_table "organization_types", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "organization_users", force: :cascade do |t|
    t.integer  "organization_id"
    t.integer  "user_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.boolean  "contact",         default: true
  end

  create_table "organizations", force: :cascade do |t|
    t.string   "name"
    t.string   "address"
    t.string   "email"
    t.string   "phone_number"
    t.integer  "organization_type_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "permitters", force: :cascade do |t|
    t.string   "name"
    t.string   "phone_number"
    t.text     "address"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.text     "email"
  end

  create_table "permitters_users", force: :cascade do |t|
    t.integer "permitter_id"
    t.integer "user_id"
    t.boolean "contact"
  end

  create_table "plan_users", force: :cascade do |t|
    t.integer "user_id"
    t.integer "plan_id"
    t.string  "role"
  end

  create_table "plan_venues", force: :cascade do |t|
    t.integer "plan_id"
    t.integer "venue_id"
  end

  create_table "plans", force: :cascade do |t|
    t.string   "name"
    t.integer  "owner_id"
    t.boolean  "alcohol"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "event_type_id"
    t.integer  "organization_id"
    t.string   "workflow_state"
    t.text     "event_contact"
    t.boolean  "responsibility"
    t.boolean  "cpr"
    t.boolean  "communication"
    t.string   "post_event_name"
    t.string   "post_event_email"
    t.string   "post_event_phone"
    t.integer  "creator_id"
    t.integer  "venue_id"
    t.string   "communication_phone"
    t.boolean  "staff_responsibility"
    t.boolean  "mci",                               default: false
    t.datetime "approval_date"
    t.boolean  "staff_responsibility_reminder_1wk"
    t.boolean  "staff_responsibility_reminder_2wk"
    t.boolean  "deleted",                           default: false
    t.text     "deleted_reason"
  end

  create_table "post_event_treatment_reports", force: :cascade do |t|
    t.integer  "plan_id"
    t.integer  "creator_id"
    t.integer  "actual_crowd_size"
    t.text     "resource_differences"
    t.string   "medical_resource_sufficiency"
    t.text     "medical_resource_sufficiency_explanation"
    t.text     "other_comments"
    t.boolean  "submitted"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.text     "weather"
  end

  add_index "post_event_treatment_reports", ["plan_id"], name: "index_post_event_treatment_reports_on_plan_id", using: :btree

  create_table "provider_confirmations", force: :cascade do |t|
    t.integer  "organization_id"
    t.integer  "medical_asset_id"
    t.string   "medical_asset_type"
    t.integer  "requester_id"
    t.string   "workflow_state"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
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

  create_table "supplementary_documents", force: :cascade do |t|
    t.text     "name"
    t.text     "description"
    t.text     "file"
    t.integer  "parent_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "parent_type"
    t.boolean  "email",         default: true
    t.boolean  "staff_contact", default: false
  end

  create_table "transportation_records", force: :cascade do |t|
    t.integer  "post_event_treatment_report_id"
    t.text     "chief_complaint"
    t.integer  "transport_id"
    t.text     "destination"
    t.datetime "transported_at"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "transportation_records", ["post_event_treatment_report_id"], name: "index_transportation_records_on_post_event_treatment_report_id", using: :btree
  add_index "transportation_records", ["transport_id"], name: "index_transportation_records_on_transport_id", using: :btree

  create_table "transports", force: :cascade do |t|
    t.string   "name"
    t.string   "level"
    t.integer  "organization_id"
    t.decimal  "lat",                    precision: 10, scale: 6
    t.decimal  "lng",                    precision: 10, scale: 6
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.integer  "operation_period_id"
    t.string   "contact_name"
    t.string   "contact_phone"
    t.text     "location"
    t.text     "service_area"
    t.string   "planning_contact_email"
  end

  create_table "transports_users", force: :cascade do |t|
    t.integer "transport_id"
    t.integer "user_id"
    t.boolean "contact"
  end

  create_table "treatment_records", force: :cascade do |t|
    t.integer  "post_event_treatment_report_id"
    t.text     "problem_description"
    t.integer  "persons_count"
    t.text     "treatment"
    t.text     "outcome"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "treatment_records", ["post_event_treatment_report_id"], name: "index_treatment_records_on_post_event_treatment_report_id", using: :btree

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
    t.integer  "roles_mask"
    t.string   "name"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "venues", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "version_associations", force: :cascade do |t|
    t.integer "version_id"
    t.string  "foreign_key_name", null: false
    t.integer "foreign_key_id"
  end

  add_index "version_associations", ["foreign_key_name", "foreign_key_id"], name: "index_version_associations_on_foreign_key", using: :btree
  add_index "version_associations", ["version_id"], name: "index_version_associations_on_version_id", using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.integer  "transaction_id"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree
  add_index "versions", ["transaction_id"], name: "index_versions_on_transaction_id", using: :btree

  add_foreign_key "notification_group_memberships", "notification_groups"
  add_foreign_key "notification_group_memberships", "users"
end
