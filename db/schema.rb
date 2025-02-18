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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140323104648) do

  create_table "api_requests", :force => true do |t|
    t.string   "model_type"
    t.text     "request_options"
    t.text     "response_body"
    t.integer  "response_code"
    t.string   "status"
    t.string   "run_method"
    t.text     "run_args_hash"
    t.string   "request_url"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "api_requests", ["created_at"], :name => "index_api_requests_on_created_at"
  add_index "api_requests", ["model_type"], :name => "index_api_requests_on_model_type"
  add_index "api_requests", ["status"], :name => "index_api_requests_on_status"
  add_index "api_requests", ["updated_at"], :name => "index_api_requests_on_updated_at"

  create_table "broker_calls", :force => true do |t|
    t.integer  "caller_id"
    t.integer  "nugget_id"
    t.string   "call_result"
    t.string   "call_comments"
    t.string   "broker_name"
    t.string   "broker_email"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "broker_email_attachments", :force => true do |t|
    t.integer  "broker_email_id"
    t.string   "file"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "broker_email_attachments_listing_nuggets", :id => false, :force => true do |t|
    t.integer "broker_email_attachment_id"
    t.integer "listing_nugget_id"
  end

  create_table "broker_emails", :force => true do |t|
    t.integer  "nugget_id"
    t.string   "from"
    t.string   "to"
    t.string   "subject"
    t.text     "body"
    t.string   "review_reason"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.boolean  "parsed",                 :default => false
    t.boolean  "spam",                   :default => false
    t.boolean  "need_supervisor_review", :default => false
  end

  create_table "buildings", :force => true do |t|
    t.string   "name"
    t.string   "size"
    t.string   "size_units"
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
    t.string   "api_uuid"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "buildings", ["api_uuid"], :name => "index_buildings_on_api_uuid"
  add_index "buildings", ["city"], :name => "index_buildings_on_city"
  add_index "buildings", ["state"], :name => "index_buildings_on_state"
  add_index "buildings", ["street"], :name => "index_buildings_on_street"
  add_index "buildings", ["zipcode"], :name => "index_buildings_on_zipcode"

  create_table "duplicates", :force => true do |t|
    t.integer  "nugget_id"
    t.integer  "compared_to_nugget_id"
    t.integer  "user_id"
    t.string   "duplicate_status"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  create_table "listing_attachments", :force => true do |t|
    t.integer  "listing_id"
    t.string   "file"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "listing_nuggets", :force => true do |t|
    t.integer  "broker_email_id"
    t.string   "broker_email_to"
    t.string   "broker_email_from"
    t.string   "broker_email_subject"
    t.text     "broker_email_body"
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.boolean  "listing_extracted",    :default => false
  end

  create_table "listings", :force => true do |t|
    t.string   "listing_type"
    t.string   "metro_listed_in"
    t.string   "building_name"
    t.string   "unit_number"
    t.string   "street_address"
    t.string   "street_address2"
    t.string   "street_address3"
    t.string   "city"
    t.string   "state_province"
    t.string   "country"
    t.decimal  "latitude"
    t.decimal  "longitude"
    t.string   "neighborhood"
    t.string   "zip_postal_code"
    t.decimal  "space"
    t.string   "space_units"
    t.string   "description"
    t.string   "title"
    t.decimal  "lease_rate"
    t.string   "lease_rate_units"
    t.string   "broker_first_name"
    t.string   "broker_last_name"
    t.string   "broker_email"
    t.string   "broker_phone"
    t.string   "broker2_first_name"
    t.string   "broker2_last_name"
    t.string   "broker2_email"
    t.string   "broker2_phone"
    t.string   "brokerage_name"
    t.string   "landlord_name"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.string   "state"
    t.integer  "listing_nugget_id"
    t.boolean  "processed",          :default => false
  end

  add_index "listings", ["processed"], :name => "index_listings_on_processed"

  create_table "messages", :force => true do |t|
    t.text     "message_body"
    t.datetime "received_at"
    t.datetime "began_processing_at"
    t.datetime "finished_processing_at"
    t.datetime "failed_at"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  create_table "nugget_signages", :force => true do |t|
    t.integer  "nugget_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "signage"
    t.string   "signage2"
  end

  create_table "nugget_state_transitions", :force => true do |t|
    t.integer  "nugget_id"
    t.string   "event"
    t.string   "from"
    t.string   "to"
    t.datetime "created_at"
    t.string   "state_message"
  end

  add_index "nugget_state_transitions", ["nugget_id"], :name => "index_nugget_state_transitions_on_nugget_id"

  create_table "nuggets", :force => true do |t|
    t.string   "state"
    t.decimal  "latitude"
    t.decimal  "longitude"
    t.string   "submitter"
    t.string   "submission_method"
    t.datetime "submitted_at",              :null => false
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.string   "signage_address"
    t.string   "signage_city"
    t.string   "signage_state"
    t.string   "signage_county"
    t.string   "signage_neighborhood"
    t.datetime "editable_until"
    t.string   "signage_phone"
    t.string   "signage_listing_type"
    t.string   "message_id"
    t.string   "submitter_notes"
    t.string   "signage_intersection"
    t.string   "contact_broker_fake_name"
    t.string   "contact_broker_fake_email"
    t.integer  "origination_nugget_id"
    t.string   "broker_email_to"
    t.string   "broker_email_from"
    t.string   "broker_email_subject"
    t.text     "broker_email_body"
    t.integer  "origination_email_id"
  end

  add_index "nuggets", ["contact_broker_fake_email"], :name => "index_nuggets_on_contact_broker_fake_email"
  add_index "nuggets", ["contact_broker_fake_name"], :name => "index_nuggets_on_contact_broker_fake_name"
  add_index "nuggets", ["created_at"], :name => "index_nuggets_on_created_at"
  add_index "nuggets", ["latitude"], :name => "index_nuggets_on_latitude"
  add_index "nuggets", ["longitude"], :name => "index_nuggets_on_longitude"
  add_index "nuggets", ["state"], :name => "index_nuggets_on_state"
  add_index "nuggets", ["submitted_at"], :name => "index_nuggets_on_submitted_at"
  add_index "nuggets", ["submitter"], :name => "index_nuggets_on_submitter"
  add_index "nuggets", ["updated_at"], :name => "index_nuggets_on_updated_at"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "roles", ["name", "resource_type", "resource_id"], :name => "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "spaces", :force => true do |t|
    t.string   "space_type"
    t.text     "description"
    t.string   "unit_number"
    t.string   "rate"
    t.string   "rate_units"
    t.string   "floor_number"
    t.string   "api_uuid"
    t.string   "api_building_uuid"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "spaces", ["api_building_uuid"], :name => "index_spaces_on_api_building_uuid"
  add_index "spaces", ["api_uuid"], :name => "index_spaces_on_api_uuid"
  add_index "spaces", ["space_type"], :name => "index_spaces_on_space_type"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "name"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], :name => "index_users_roles_on_user_id_and_role_id"

end
