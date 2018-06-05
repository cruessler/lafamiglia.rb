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

ActiveRecord::Schema.define(version: 20150523182037) do

  create_table "building_queue_items", force: :cascade do |t|
    t.integer  "villa_id"
    t.integer  "building_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "build_time"
    t.datetime "completed_at"
    t.index ["villa_id"], name: "index_building_queue_items_on_villa_id"
  end

  create_table "message_statuses", force: :cascade do |t|
    t.integer  "player_id"
    t.integer  "message_id"
    t.boolean  "read"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["message_id"], name: "index_message_statuses_on_message_id"
    t.index ["player_id"], name: "index_message_statuses_on_player_id"
  end

  create_table "messages", force: :cascade do |t|
    t.integer  "sender_id"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "sent_at"
  end

  create_table "messages_receivers", id: false, force: :cascade do |t|
    t.integer "message_id", null: false
    t.integer "player_id",  null: false
    t.index ["message_id"], name: "index_messages_receivers_on_message_id"
    t.index ["player_id"], name: "index_messages_receivers_on_player_id"
  end

  create_table "movements", force: :cascade do |t|
    t.string   "type",       limit: 255
    t.integer  "origin_id"
    t.integer  "target_id"
    t.integer  "unit_1"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "resource_1"
    t.float    "resource_2"
    t.float    "resource_3"
    t.datetime "arrives_at"
    t.integer  "unit_2"
    t.index ["origin_id"], name: "index_movements_on_origin_id"
    t.index ["target_id"], name: "index_movements_on_target_id"
  end

  create_table "occupations", force: :cascade do |t|
    t.datetime "succeeds_at"
    t.integer  "target_id"
    t.integer  "origin_id"
    t.integer  "unit_1"
    t.integer  "unit_2"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["origin_id"], name: "index_occupations_on_origin_id"
    t.index ["target_id"], name: "index_occupations_on_target_id", unique: true
  end

  create_table "players", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.integer  "failed_attempts",                    default: 0,  null: false
    t.string   "unlock_token",           limit: 255
    t.datetime "locked_at"
    t.integer  "points"
    t.integer  "unread_messages_count"
    t.integer  "unread_reports_count"
    t.index ["confirmation_token"], name: "index_players_on_confirmation_token", unique: true
    t.index ["email"], name: "index_players_on_email", unique: true
    t.index ["name"], name: "index_players_on_name", unique: true
    t.index ["points"], name: "index_players_on_points"
    t.index ["reset_password_token"], name: "index_players_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_players_on_unlock_token", unique: true
  end

  create_table "reports", force: :cascade do |t|
    t.string   "type",         limit: 255
    t.integer  "player_id"
    t.string   "title",        limit: 255
    t.text     "data"
    t.boolean  "read"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "delivered_at"
    t.index ["player_id", "delivered_at"], name: "index_reports_on_player_id_and_delivered_at"
  end

  create_table "research_queue_items", force: :cascade do |t|
    t.integer  "villa_id"
    t.integer  "research_id"
    t.integer  "research_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "completed_at"
    t.index ["villa_id"], name: "index_research_queue_items_on_villa_id"
  end

  create_table "unit_queue_items", force: :cascade do |t|
    t.integer  "villa_id"
    t.integer  "unit_id"
    t.integer  "number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "completed_at"
    t.index ["villa_id"], name: "index_unit_queue_items_on_villa_id"
  end

  create_table "villas", force: :cascade do |t|
    t.integer  "x"
    t.integer  "y"
    t.string   "name",                       limit: 255
    t.integer  "player_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "resource_1"
    t.float    "resource_2"
    t.float    "resource_3"
    t.integer  "storage_capacity"
    t.integer  "building_1"
    t.integer  "building_queue_items_count"
    t.integer  "unit_queue_items_count"
    t.integer  "used_supply"
    t.integer  "supply"
    t.integer  "unit_1"
    t.integer  "research_queue_items_count"
    t.integer  "building_2"
    t.integer  "research_1"
    t.integer  "points"
    t.datetime "processed_until"
    t.integer  "unit_2"
    t.boolean  "is_occupied"
    t.index ["player_id"], name: "index_villas_on_player_id"
    t.index ["x", "y"], name: "index_villas_on_x_and_y", unique: true
  end

end
