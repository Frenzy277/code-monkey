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

ActiveRecord::Schema.define(version: 20141208004859) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "feedbacks", force: true do |t|
    t.integer  "giver_id"
    t.integer  "skill_id"
    t.text     "content"
    t.boolean  "recommended"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "feedbacks", ["giver_id"], name: "index_feedbacks_on_giver_id", using: :btree
  add_index "feedbacks", ["skill_id"], name: "index_feedbacks_on_skill_id", using: :btree

  create_table "languages", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_url"
  end

  create_table "queue_items", force: true do |t|
    t.integer  "skill_id"
    t.integer  "mentee_id"
    t.string   "status",     default: "pending"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "support"
    t.integer  "mentor_id"
  end

  add_index "queue_items", ["mentee_id"], name: "index_queue_items_on_mentee_id", using: :btree
  add_index "queue_items", ["mentor_id"], name: "index_queue_items_on_mentor_id", using: :btree
  add_index "queue_items", ["skill_id"], name: "index_queue_items_on_skill_id", using: :btree

  create_table "skills", force: true do |t|
    t.integer "mentor_id"
    t.integer "language_id"
    t.integer "helped_total", default: 0
    t.date    "experience"
    t.text    "description"
  end

  add_index "skills", ["language_id"], name: "index_skills_on_language_id", using: :btree
  add_index "skills", ["mentor_id"], name: "index_skills_on_mentor_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "password_digest"
    t.integer  "balance",         default: 1
    t.text     "about_me"
    t.string   "image_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
