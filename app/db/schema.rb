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

ActiveRecord::Schema[8.0].define(version: 2025_01_23_025307) do
  create_table "questions", force: :cascade do |t|
    t.integer "topic_id", null: false
    t.integer "type_id", null: false
    t.string "img"
    t.text "template_text", null: false
    t.text "equation"
    t.json "variables", default: []
    t.text "answer"
    t.integer "correct_submissions", default: 0
    t.integer "total_submissions", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["topic_id"], name: "index_questions_on_topic_id"
    t.index ["type_id"], name: "index_questions_on_type_id"
  end

  create_table "topics", force: :cascade do |t|
    t.integer "topic_id", null: false
    t.string "topic_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["topic_id"], name: "index_topics_on_topic_id", unique: true
  end

  create_table "types", force: :cascade do |t|
    t.integer "type_id", null: false
    t.string "type_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["type_id"], name: "index_types_on_type_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.integer "role", default: 0, null: false
    t.string "email", null: false
    t.integer "correct_submissions", default: 0, null: false
    t.integer "total_submissions", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "uid"
    t.string "provider"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "questions", "topics"
  add_foreign_key "questions", "types"
end
