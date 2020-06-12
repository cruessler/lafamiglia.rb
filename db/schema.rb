# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_06_03_133924) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "building_queue_items", id: :serial, force: :cascade do |t|
    t.integer "villa_id"
    t.integer "building_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "build_time"
    t.datetime "completed_at"
    t.index ["completed_at"], name: "index_building_queue_items_on_completed_at"
    t.index ["villa_id"], name: "index_building_queue_items_on_villa_id"
  end

  create_table "message_statuses", id: :serial, force: :cascade do |t|
    t.integer "player_id"
    t.integer "message_id"
    t.boolean "read"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["message_id"], name: "index_message_statuses_on_message_id"
    t.index ["player_id"], name: "index_message_statuses_on_player_id"
  end

  create_table "messages", id: :serial, force: :cascade do |t|
    t.integer "sender_id"
    t.text "text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "sent_at"
    t.index ["sender_id"], name: "index_messages_on_sender_id"
  end

  create_table "messages_receivers", id: false, force: :cascade do |t|
    t.integer "message_id", null: false
    t.integer "player_id", null: false
    t.index ["message_id"], name: "index_messages_receivers_on_message_id"
    t.index ["player_id"], name: "index_messages_receivers_on_player_id"
  end

  create_table "movements", id: :serial, force: :cascade do |t|
    t.string "type"
    t.integer "origin_id"
    t.integer "target_id"
    t.integer "unit_1"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float "resource_1"
    t.float "resource_2"
    t.float "resource_3"
    t.datetime "arrives_at"
    t.integer "unit_2"
    t.index ["arrives_at"], name: "index_movements_on_arrives_at"
    t.index ["origin_id"], name: "index_movements_on_origin_id"
    t.index ["target_id"], name: "index_movements_on_target_id"
  end

  create_table "occupations", id: :serial, force: :cascade do |t|
    t.datetime "succeeds_at"
    t.integer "target_id"
    t.integer "origin_id"
    t.integer "unit_1"
    t.integer "unit_2"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["origin_id"], name: "index_occupations_on_origin_id"
    t.index ["target_id"], name: "index_occupations_on_target_id", unique: true
  end

  create_table "players", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.integer "points"
    t.integer "unread_messages_count"
    t.integer "unread_reports_count"
    t.index ["confirmation_token"], name: "index_players_on_confirmation_token", unique: true
    t.index ["email"], name: "index_players_on_email", unique: true
    t.index ["name"], name: "index_players_on_name", unique: true
    t.index ["points"], name: "index_players_on_points"
    t.index ["reset_password_token"], name: "index_players_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_players_on_unlock_token", unique: true
  end

  create_table "reports", id: :serial, force: :cascade do |t|
    t.string "type"
    t.integer "player_id"
    t.string "title"
    t.text "data"
    t.boolean "read"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "delivered_at"
    t.index ["player_id", "delivered_at"], name: "index_reports_on_player_id_and_delivered_at"
  end

  create_table "research_queue_items", id: :serial, force: :cascade do |t|
    t.integer "villa_id"
    t.integer "research_id"
    t.integer "research_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "completed_at"
    t.index ["completed_at"], name: "index_research_queue_items_on_completed_at"
    t.index ["villa_id"], name: "index_research_queue_items_on_villa_id"
  end

  create_table "unit_queue_items", id: :serial, force: :cascade do |t|
    t.integer "villa_id"
    t.integer "unit_id"
    t.integer "number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "completed_at"
    t.index ["completed_at"], name: "index_unit_queue_items_on_completed_at"
    t.index ["villa_id"], name: "index_unit_queue_items_on_villa_id"
  end

  create_table "villas", id: :serial, force: :cascade do |t|
    t.integer "x"
    t.integer "y"
    t.string "name"
    t.integer "player_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float "resource_1"
    t.float "resource_2"
    t.float "resource_3"
    t.integer "storage_capacity"
    t.integer "building_1"
    t.integer "building_queue_items_count"
    t.integer "unit_queue_items_count"
    t.integer "used_supply"
    t.integer "supply"
    t.integer "unit_1"
    t.integer "research_queue_items_count"
    t.integer "building_2"
    t.integer "research_1"
    t.integer "points"
    t.datetime "processed_until"
    t.integer "unit_2"
    t.boolean "is_occupied"
    t.index ["player_id"], name: "index_villas_on_player_id"
    t.index ["processed_until"], name: "index_villas_on_processed_until"
    t.index ["x", "y"], name: "index_villas_on_x_and_y", unique: true
  end

end
