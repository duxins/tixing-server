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

ActiveRecord::Schema.define(version: 20141025150328) do

  create_table "devices", force: true do |t|
    t.string   "name"
    t.string   "token"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "timezone",   default: 8
  end

  add_index "devices", ["user_id"], name: "index_devices_on_user_id", using: :btree

  create_table "installations", force: true do |t|
    t.integer  "user_id"
    t.integer  "service_id"
    t.text     "preferences"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "installations", ["service_id"], name: "index_installations_on_service_id", using: :btree
  add_index "installations", ["user_id", "service_id"], name: "index_installations_on_user_id_and_service_id", unique: true, using: :btree
  add_index "installations", ["user_id"], name: "index_installations_on_user_id", using: :btree

  create_table "notifications", force: true do |t|
    t.string   "message",    limit: 1000
    t.string   "sound"
    t.integer  "user_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notifications", ["deleted_at"], name: "index_notifications_on_deleted_at", using: :btree
  add_index "notifications", ["user_id"], name: "index_notifications_on_user_id", using: :btree

  create_table "services", force: true do |t|
    t.string   "name"
    t.string   "icon"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "password_digest"
    t.string   "auth_token"
    t.string   "sound",           default: "tixing"
    t.boolean  "silent_at_night", default: false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["auth_token"], name: "index_users_on_auth_token", using: :btree
  add_index "users", ["deleted_at"], name: "index_users_on_deleted_at", using: :btree
  add_index "users", ["name"], name: "index_users_on_name", unique: true, using: :btree

  create_table "weibo_followers", force: true do |t|
    t.integer  "uid",        limit: 8,    null: false
    t.integer  "user_id"
    t.string   "keyword",    limit: 1000
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "weibo_followers", ["uid"], name: "index_weibo_followers_on_uid", using: :btree
  add_index "weibo_followers", ["user_id"], name: "index_weibo_followers_on_user_id", using: :btree

  create_table "weibo_users", force: true do |t|
    t.integer  "uid",             limit: 8
    t.string   "name"
    t.string   "avatar"
    t.text     "metadata"
    t.string   "last_weibo_id"
    t.string   "last_checked_at"
    t.string   "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "weibo_users", ["deleted_at"], name: "index_weibo_users_on_deleted_at", using: :btree
  add_index "weibo_users", ["uid"], name: "index_weibo_users_on_uid", unique: true, using: :btree

end
