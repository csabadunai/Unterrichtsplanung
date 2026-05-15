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

ActiveRecord::Schema[8.1].define(version: 2026_05_15_090353) do
  create_table "collaborations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "role"
    t.integer "subject_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["subject_id"], name: "index_collaborations_on_subject_id"
    t.index ["user_id"], name: "index_collaborations_on_user_id"
  end

  create_table "lessons", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "duration", default: 1
    t.datetime "start_time"
    t.integer "subject_id", null: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["subject_id"], name: "index_lessons_on_subject_id"
  end

  create_table "phases", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.text "differentiation"
    t.integer "duration"
    t.integer "lesson_id", null: false
    t.string "materials"
    t.integer "position"
    t.string "social"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["lesson_id"], name: "index_phases_on_lesson_id"
  end

  create_table "subjects", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "group"
    t.string "name"
    t.string "room"
    t.text "schedule_data"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_subjects_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "collaborations", "subjects"
  add_foreign_key "collaborations", "users"
  add_foreign_key "lessons", "subjects"
  add_foreign_key "phases", "lessons"
  add_foreign_key "subjects", "users"
end
