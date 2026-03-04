# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2026_03_04_020344) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.integer "user_id"
    t.string "cep"
    t.string "uf"
    t.string "address"
    t.string "complement"
    t.string "city"
    t.string "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "number"
    t.float "latitude"
    t.float "longitude"
  end

  create_table "alert_votes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "alert_id", null: false
    t.integer "vote_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["alert_id"], name: "index_alert_votes_on_alert_id"
    t.index ["user_id", "alert_id"], name: "index_alert_votes_on_user_id_and_alert_id", unique: true
    t.index ["user_id"], name: "index_alert_votes_on_user_id"
  end

  create_table "alerts", force: :cascade do |t|
    t.integer "alert_type"
    t.integer "alert"
    t.string "location"
    t.integer "relevant"
    t.integer "inappropriate"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.text "description"
    t.float "latitude"
    t.float "longitude"
  end

  create_table "plan_subscriptions", force: :cascade do |t|
    t.integer "user_id"
    t.integer "plan_id"
    t.date "duration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "plans", force: :cascade do |t|
    t.string "name"
    t.integer "price_cents"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "user_agent"
    t.string "ip_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.boolean "verified", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "full_name"
    t.string "username"
    t.integer "geopoints"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "alert_votes", "alerts"
  add_foreign_key "alert_votes", "users"
  add_foreign_key "sessions", "users"
end
