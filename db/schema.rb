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

ActiveRecord::Schema.define(version: 20141121070045) do

  create_table "devices", force: true do |t|
    t.string   "name"
    t.string   "token"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "timezone",   default: 8
  end

  add_index "devices", ["user_id"], name: "index_devices_on_user_id", using: :btree

  create_table "feedbacks", force: true do |t|
    t.integer  "user_id"
    t.text     "content"
    t.text     "memo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

  create_table "netease_monitorings", force: true do |t|
    t.integer  "user_id"
    t.string   "keyword"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "netease_monitorings", ["user_id"], name: "index_netease_monitorings_on_user_id", using: :btree

  create_table "notifications", force: true do |t|
    t.string   "title"
    t.string   "message",    limit: 1000
    t.string   "thumb"
    t.string   "url"
    t.string   "sound"
    t.integer  "user_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "service_id"
  end

  add_index "notifications", ["deleted_at"], name: "index_notifications_on_deleted_at", using: :btree
  add_index "notifications", ["service_id"], name: "index_notifications_on_service_id", using: :btree
  add_index "notifications", ["user_id"], name: "index_notifications_on_user_id", using: :btree

  create_table "rpush_apps", force: true do |t|
    t.string   "name",                                null: false
    t.string   "environment"
    t.text     "certificate"
    t.string   "password"
    t.integer  "connections",             default: 1, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type",                                null: false
    t.string   "auth_key"
    t.string   "client_id"
    t.string   "client_secret"
    t.string   "access_token"
    t.datetime "access_token_expiration"
  end

  create_table "rpush_feedback", force: true do |t|
    t.string   "device_token", limit: 64, null: false
    t.datetime "failed_at",               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "app_id"
  end

  add_index "rpush_feedback", ["device_token"], name: "index_rpush_feedback_on_device_token", using: :btree

  create_table "rpush_notifications", force: true do |t|
    t.integer  "badge"
    t.string   "device_token",      limit: 64
    t.string   "sound",                              default: "default"
    t.string   "alert"
    t.text     "data"
    t.integer  "expiry",                             default: 86400
    t.boolean  "delivered",                          default: false,     null: false
    t.datetime "delivered_at"
    t.boolean  "failed",                             default: false,     null: false
    t.datetime "failed_at"
    t.integer  "error_code"
    t.text     "error_description"
    t.datetime "deliver_after"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "alert_is_json",                      default: false
    t.string   "type",                                                   null: false
    t.string   "collapse_key"
    t.boolean  "delay_while_idle",                   default: false,     null: false
    t.text     "registration_ids",  limit: 16777215
    t.integer  "app_id",                                                 null: false
    t.integer  "retries",                            default: 0
    t.string   "uri"
    t.datetime "fail_after"
    t.boolean  "processing",                         default: false,     null: false
    t.integer  "priority"
    t.text     "url_args"
    t.string   "category"
  end

  add_index "rpush_notifications", ["app_id", "delivered", "failed", "deliver_after"], name: "index_rapns_notifications_multi", using: :btree
  add_index "rpush_notifications", ["delivered", "failed"], name: "index_rpush_notifications_multi", using: :btree

  create_table "services", force: true do |t|
    t.string   "name"
    t.string   "icon"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
  end

  create_table "settings", force: true do |t|
    t.string   "var",                   null: false
    t.text     "value"
    t.integer  "thing_id"
    t.string   "thing_type", limit: 30
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "password_digest"
    t.string   "auth_token"
    t.string   "sound",           default: "tixing"
    t.boolean  "silent_at_night", default: false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "disabled",        default: false
  end

  add_index "users", ["auth_token"], name: "index_users_on_auth_token", using: :btree
  add_index "users", ["deleted_at"], name: "index_users_on_deleted_at", using: :btree
  add_index "users", ["name"], name: "index_users_on_name", unique: true, using: :btree

  create_table "v2ex_monitorings", force: true do |t|
    t.integer  "user_id"
    t.string   "keyword"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "v2ex_monitorings", ["user_id"], name: "index_v2ex_monitorings_on_user_id", using: :btree

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
    t.integer  "followers_count",           default: 0
  end

  add_index "weibo_users", ["deleted_at"], name: "index_weibo_users_on_deleted_at", using: :btree
  add_index "weibo_users", ["uid"], name: "index_weibo_users_on_uid", unique: true, using: :btree

end
