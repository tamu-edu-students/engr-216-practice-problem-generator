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

ActiveRecord::Schema[8.0].define(version: 2025_03_21_210128) do
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
    t.text "explanation"
    t.integer "round_decimals"
    t.json "variable_ranges"
    t.json "variable_decimals"
    t.index ["topic_id"], name: "index_questions_on_topic_id"
    t.index ["type_id"], name: "index_questions_on_type_id"
  end

  create_table "submissions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "question_id", null: false
    t.boolean "correct", default: false, null: false
    t.datetime "submitted_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_submissions_on_question_id"
    t.index ["user_id"], name: "index_submissions_on_user_id"
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
    t.string "first_name"
    t.string "last_name"
    t.integer "role", default: 0, null: false
    t.string "email"
    t.integer "correct_submissions", default: 0, null: false
    t.integer "total_submissions", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "uid"
    t.string "provider"
    t.integer "instructor_id"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "questions", "topics"
  add_foreign_key "questions", "types"
  add_foreign_key "submissions", "questions"
  add_foreign_key "submissions", "users"
  add_foreign_key "users", "users", column: "instructor_id"
end
