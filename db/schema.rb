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

ActiveRecord::Schema.define(version: 20160417124529) do

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable"
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type"

  create_table "clips", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "message_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "clips", ["message_id"], name: "index_clips_on_message_id"
  add_index "clips", ["user_id", "message_id"], name: "index_clips_on_user_id_and_message_id", unique: true
  add_index "clips", ["user_id"], name: "index_clips_on_user_id"

  create_table "favorites", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "message_board_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "favorites", ["created_at"], name: "index_favorites_on_created_at"
  add_index "favorites", ["message_board_id"], name: "index_favorites_on_message_board_id"
  add_index "favorites", ["user_id"], name: "index_favorites_on_user_id"

  create_table "items", force: :cascade do |t|
    t.string   "asin"
    t.string   "title"
    t.string   "description"
    t.string   "detail_page_url"
    t.string   "small_image"
    t.string   "medium_image"
    t.string   "large_image"
    t.string   "raw_info"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "items", ["asin"], name: "index_items_on_asin", unique: true

  create_table "message_boards", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "item_id"
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "message_boards", ["item_id"], name: "index_message_boards_on_item_id"
  add_index "message_boards", ["updated_at"], name: "index_message_boards_on_updated_at"
  add_index "message_boards", ["user_id"], name: "index_message_boards_on_user_id"

  create_table "messages", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "message_board_id"
    t.text     "content"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "video_url"
  end

  add_index "messages", ["message_board_id"], name: "index_messages_on_message_board_id"
  add_index "messages", ["user_id", "updated_at"], name: "index_messages_on_user_id_and_updated_at"
  add_index "messages", ["user_id"], name: "index_messages_on_user_id"

  create_table "ownerships", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "item_id"
    t.string   "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "ownerships", ["item_id"], name: "index_ownerships_on_item_id"
  add_index "ownerships", ["user_id", "item_id", "type"], name: "index_ownerships_on_user_id_and_item_id_and_type", unique: true
  add_index "ownerships", ["user_id"], name: "index_ownerships_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "remember_digest"
    t.string   "activation_digest"
    t.boolean  "activated",         default: false
    t.datetime "activated_at"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

end
