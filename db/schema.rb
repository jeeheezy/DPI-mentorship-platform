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

ActiveRecord::Schema[7.0].define(version: 2024_03_14_194117) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "pairings", force: :cascade do |t|
    t.bigint "mentor_id", null: false
    t.bigint "mentee_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mentee_id"], name: "index_pairings_on_mentee_id"
    t.index ["mentor_id"], name: "index_pairings_on_mentor_id"
  end

  create_table "participations", force: :cascade do |t|
    t.bigint "program_id", null: false
    t.bigint "user_id", null: false
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["program_id"], name: "index_participations_on_program_id"
    t.index ["user_id"], name: "index_participations_on_user_id"
  end

  create_table "programs", force: :cascade do |t|
    t.string "name"
    t.bigint "owner_id", null: false
    t.text "description"
    t.string "banner_image"
    t.string "support_contact"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id"], name: "index_programs_on_owner_id"
  end

  create_table "rankings", force: :cascade do |t|
    t.bigint "mentee_id", null: false
    t.bigint "mentor_id", null: false
    t.integer "rank"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mentee_id"], name: "index_rankings_on_mentee_id"
    t.index ["mentor_id"], name: "index_rankings_on_mentor_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "username"
    t.text "bio"
    t.string "pic"
    t.string "preferred_timezone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "pairings", "participations", column: "mentee_id"
  add_foreign_key "pairings", "participations", column: "mentor_id"
  add_foreign_key "participations", "programs"
  add_foreign_key "participations", "users"
  add_foreign_key "programs", "users", column: "owner_id"
  add_foreign_key "rankings", "participations", column: "mentee_id"
  add_foreign_key "rankings", "participations", column: "mentor_id"
end
