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

ActiveRecord::Schema[8.1].define(version: 2026_05_05_072251) do
  create_table "lessons", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "duration", default: 1
    t.datetime "start_time"
    t.string "title"
    t.datetime "updated_at", null: false
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
    t.datetime "updated_at", null: false
    t.index ["lesson_id"], name: "index_phases_on_lesson_id"
  end

  add_foreign_key "phases", "lessons"
end
