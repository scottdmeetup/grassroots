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

ActiveRecord::Schema.define(version: 20140430201344) do

  create_table "organizations", force: true do |t|
    t.string   "name"
    t.datetime "ruling_year"
    t.text     "mission_statement"
    t.string   "guidestar_membership"
    t.string   "ein"
    t.string   "street1"
    t.string   "street2"
    t.string   "city"
    t.integer  "state_id"
    t.string   "zip"
    t.integer  "ntee_major_category_id"
    t.string   "funding_method"
    t.integer  "user_id"
    t.string   "cause"
  end

  create_table "private_messages", force: true do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.string   "subject"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id"
  end

  create_table "projects", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "skills"
    t.string   "causes"
    t.datetime "deadline"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "organization_id"
    t.integer  "estimated_hours"
    t.string   "state"
  end

  create_table "users", force: true do |t|
    t.integer  "organization_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "interests"
    t.string   "skills"
    t.string   "street1"
    t.string   "street2"
    t.string   "city"
    t.integer  "state_id"
    t.integer  "phone_number"
    t.string   "zip"
    t.boolean  "organization_administrator"
    t.boolean  "organization_staff"
    t.boolean  "volunteer"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "position"
    t.integer  "project_id"
  end

end
