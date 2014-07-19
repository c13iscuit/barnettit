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

ActiveRecord::Schema.define(version: 20140719173107) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: true do |t|
    t.text     "description",             null: false
    t.integer  "post_id",                 null: false
    t.integer  "user_id",                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "score",       default: 0
  end

  create_table "posts", force: true do |t|
    t.string   "title",                   null: false
    t.text     "description"
    t.integer  "user_id",                 null: false
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url"
    t.integer  "score",       default: 0
    t.string   "avatar"
    t.integer  "source_id",   default: 8
  end

  create_table "sources", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscriptions", force: true do |t|
    t.integer  "user_id",    null: false
    t.integer  "source_id",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "username",   null: false
    t.string   "uid"
    t.string   "provider"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar"
  end

  add_index "users", ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true, using: :btree

  create_table "votes", force: true do |t|
    t.integer "user_id",      null: false
    t.integer "votable_id",   null: false
    t.string  "votable_type", null: false
    t.integer "value"
  end

end
