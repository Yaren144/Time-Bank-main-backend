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

ActiveRecord::Schema[8.1].define(version: 2026_05_06_131418) do
  create_table "reviews", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.text "comment"
    t.datetime "created_at", null: false
    t.integer "rating"
    t.bigint "reviewer_id", null: false
    t.bigint "service_request_id", null: false
    t.datetime "updated_at", null: false
    t.index ["reviewer_id"], name: "index_reviews_on_reviewer_id"
    t.index ["service_request_id"], name: "index_reviews_on_service_request_id"
  end

  create_table "service_requests", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "message"
    t.bigint "requester_id", null: false
    t.bigint "service_id", null: false
    t.string "status"
    t.datetime "updated_at", null: false
    t.index ["requester_id"], name: "index_service_requests_on_requester_id"
    t.index ["service_id"], name: "index_service_requests_on_service_id"
  end

  create_table "services", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "category"
    t.datetime "created_at", null: false
    t.integer "credits"
    t.text "description"
    t.string "status"
    t.string "title"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_services_on_user_id"
  end

  create_table "transactions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "amount"
    t.datetime "created_at", null: false
    t.string "description"
    t.bigint "receiver_id", null: false
    t.bigint "sender_id", null: false
    t.string "transaction_type"
    t.datetime "updated_at", null: false
    t.index ["receiver_id"], name: "index_transactions_on_receiver_id"
    t.index ["sender_id"], name: "index_transactions_on_sender_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.string "password_digest"
    t.string "role"
    t.integer "time_credits"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "reviews", "service_requests"
  add_foreign_key "reviews", "users", column: "reviewer_id"
  add_foreign_key "service_requests", "services"
  add_foreign_key "service_requests", "users", column: "requester_id"
  add_foreign_key "services", "users"
  add_foreign_key "transactions", "users", column: "receiver_id"
  add_foreign_key "transactions", "users", column: "sender_id"
end
