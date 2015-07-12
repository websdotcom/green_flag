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

ActiveRecord::Schema.define(:version => 20150218171852) do

  create_table "green_flag_feature_decisions", :force => true do |t|
    t.integer  "feature_id",      :null => false
    t.integer  "site_visitor_id", :null => false
    t.boolean  "enabled"
    t.boolean  "manual"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "rule_id"
  end

  add_index "green_flag_feature_decisions", ["site_visitor_id", "feature_id"], :name => "index_gf_feature_decisions_on_site_visitor_id_feature_id", :unique => true

  create_table "green_flag_feature_events", :force => true do |t|
    t.integer  "feature_id",      :null => false
    t.integer  "event_type_code", :null => false
    t.integer  "count",           :null => false
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "green_flag_feature_events", ["event_type_code"], :name => "index_green_flag_feature_events_on_event_type_code"
  add_index "green_flag_feature_events", ["feature_id"], :name => "index_green_flag_feature_events_on_feature_id"

  create_table "green_flag_features", :force => true do |t|
    t.string   "code",                          :null => false
    t.string   "description"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.integer  "version_number", :default => 1, :null => false
  end

  add_index "green_flag_features", ["code"], :name => "index_green_flag_features_on_code", :unique => true

  create_table "green_flag_rules", :force => true do |t|
    t.string   "group_key",                     :null => false
    t.integer  "feature_id",                    :null => false
    t.integer  "order_by",                      :null => false
    t.integer  "percentage",     :default => 0, :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.integer  "version_number", :default => 1, :null => false
  end

  add_index "green_flag_rules", ["feature_id", "group_key", "version_number"], :name => "index_green_flag_rules_on_feature_version_and_group_key", :unique => true
  add_index "green_flag_rules", ["feature_id", "order_by", "version_number"], :name => "index_green_flag_rules_on_feature_version_and_order_by", :unique => true

  create_table "green_flag_site_visitors", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "visitor_code", :null => false
  end

  add_index "green_flag_site_visitors", ["user_id"], :name => "index_green_flag_site_visitors_on_user_id", :unique => true
  add_index "green_flag_site_visitors", ["visitor_code"], :name => "index_green_flag_site_visitors_on_visitor_code", :unique => true

end
