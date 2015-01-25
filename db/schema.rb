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

ActiveRecord::Schema.define(version: 20150123103755) do

  create_table "building_queue_items", force: true do |t|
    t.integer  "villa_id"
    t.integer  "building_id"
    t.integer  "completion_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "build_time"
  end

  add_index "building_queue_items", ["completion_time"], name: "index_building_queue_items_on_completion_time"
  add_index "building_queue_items", ["villa_id"], name: "index_building_queue_items_on_villa_id"

  create_table "message_statuses", force: true do |t|
    t.integer  "player_id"
    t.integer  "message_id"
    t.boolean  "read"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "message_statuses", ["message_id"], name: "index_message_statuses_on_message_id"
  add_index "message_statuses", ["player_id"], name: "index_message_statuses_on_player_id"

  create_table "messages", force: true do |t|
    t.integer  "sender_id"
    t.text     "text"
    t.integer  "time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages_receivers", id: false, force: true do |t|
    t.integer "message_id", null: false
    t.integer "player_id",  null: false
  end

  add_index "messages_receivers", ["message_id"], name: "index_messages_receivers_on_message_id"
  add_index "messages_receivers", ["player_id"], name: "index_messages_receivers_on_player_id"

  create_table "movements", force: true do |t|
    t.string   "type"
    t.integer  "arrival"
    t.integer  "origin_id"
    t.integer  "target_id"
    t.integer  "unit_1"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "resource_1"
    t.float    "resource_2"
    t.float    "resource_3"
  end

  add_index "movements", ["arrival"], name: "index_movements_on_arrival"
  add_index "movements", ["origin_id"], name: "index_movements_on_origin_id"
  add_index "movements", ["target_id"], name: "index_movements_on_target_id"

  create_table "players", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
  end

  add_index "players", ["confirmation_token"], name: "index_players_on_confirmation_token", unique: true
  add_index "players", ["email"], name: "index_players_on_email", unique: true
  add_index "players", ["name"], name: "index_players_on_name", unique: true
  add_index "players", ["reset_password_token"], name: "index_players_on_reset_password_token", unique: true
  add_index "players", ["unlock_token"], name: "index_players_on_unlock_token", unique: true

  create_table "reports", force: true do |t|
    t.string   "type"
    t.integer  "player_id"
    t.integer  "time"
    t.string   "title"
    t.text     "data"
    t.boolean  "read"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reports", ["player_id"], name: "index_reports_on_player_id"

  create_table "research_queue_items", force: true do |t|
    t.integer  "villa_id"
    t.integer  "research_id"
    t.integer  "research_time"
    t.integer  "completion_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "research_queue_items", ["completion_time"], name: "index_research_queue_items_on_completion_time"
  add_index "research_queue_items", ["villa_id"], name: "index_research_queue_items_on_villa_id"

  create_table "unit_queue_items", force: true do |t|
    t.integer  "villa_id"
    t.integer  "unit_id"
    t.integer  "number"
    t.integer  "completion_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "unit_queue_items", ["completion_time"], name: "index_unit_queue_items_on_completion_time"
  add_index "unit_queue_items", ["villa_id"], name: "index_unit_queue_items_on_villa_id"

  create_table "villas", force: true do |t|
    t.integer  "x"
    t.integer  "y"
    t.string   "name"
    t.integer  "player_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "resource_1"
    t.float    "resource_2"
    t.float    "resource_3"
    t.integer  "storage_capacity"
    t.integer  "last_processed"
    t.integer  "building_1"
    t.integer  "building_queue_items_count"
    t.integer  "unit_queue_items_count"
    t.integer  "used_supply"
    t.integer  "supply"
    t.integer  "unit_1"
    t.integer  "research_queue_items_count"
    t.integer  "building_2"
    t.integer  "research_1"
  end

  add_index "villas", ["player_id"], name: "index_villas_on_player_id"
  add_index "villas", ["x", "y"], name: "index_villas_on_x_and_y", unique: true

end
