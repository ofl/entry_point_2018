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

ActiveRecord::Schema.define(version: 2018_06_30_041559) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "batch_schedule_point_expirations", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "run_at", null: false, comment: "バッチ実施日時(ポイント失効日時)"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["run_at"], name: "index_batch_schedule_point_expirations_on_run_at"
    t.index ["user_id"], name: "index_batch_schedule_point_expirations_on_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.bigint "user_id", comment: "投稿者"
    t.bigint "post_id", comment: "投稿"
    t.text "body", null: false, comment: "本文"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_comments_on_post_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "point_histories", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "operation_type", null: false, comment: "(0:獲得,1:使用,2:失効)"
    t.integer "amount", default: 0, null: false, comment: "増減したポイント数"
    t.integer "total", default: 0, null: false, comment: "総ポイント数"
    t.integer "version", default: 0, null: false, comment: "衝突防止のためのバージョン"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "version"], name: "index_point_histories_on_user_id_and_version", order: { version: :desc }
    t.index ["user_id"], name: "index_point_histories_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.bigint "user_id", comment: "投稿者"
    t.string "title", null: false, comment: "タイトル"
    t.text "body", null: false, comment: "本文"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "user_auths", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "provider"
    t.string "uid"
    t.string "access_token"
    t.string "access_secret"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_auths_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", limit: 255, null: false
    t.string "encrypted_password", limit: 255, null: false
    t.string "username", limit: 15, null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.string "authentication_token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "avatar_data", comment: "アバター画像"
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "batch_schedule_point_expirations", "users"
  add_foreign_key "comments", "posts"
  add_foreign_key "comments", "users"
  add_foreign_key "posts", "users"
  add_foreign_key "user_auths", "users"
end
