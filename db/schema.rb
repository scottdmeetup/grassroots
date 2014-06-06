<<<<<<< HEAD
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

ActiveRecord::Schema.define(version: 20140606174217) do

  create_table "contracts", force: true do |t|
    t.integer  "contractor_id"
    t.integer  "volunteer_id"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id"
    t.boolean  "dropped_out"
    t.boolean  "complete"
    t.boolean  "incomplete"
    t.boolean  "work_submitted"
  end

  create_table "conversations", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "volunteer_application_id"
    t.integer  "contract_id"
  end

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
    t.string   "state_abbreviation"
    t.text     "goal"
    t.string   "contact_number"
    t.string   "contact_email"
    t.string   "budget"
  end

  create_table "private_messages", force: true do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.string   "subject"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id"
    t.integer  "conversation_id"
  end

  create_table "project_users", force: true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
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

  create_table "user_conversations", force: true do |t|
    t.integer  "user_id"
    t.integer  "conversation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.string   "time_zone"
    t.text     "bio"
    t.string   "contact_reason"
    t.string   "organization_role"
    t.boolean  "nonprofit"
    t.string   "type"
    t.string   "user_group"
    t.string   "state_abbreviation"
    t.string   "new_password_token"
  end

  create_table "volunteer_applications", force: true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.boolean  "accepted"
    t.boolean  "rejected"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "applicant_id"
    t.integer  "administrator_id"
  end

end
=======
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

ActiveRecord::Schema.define(version: 20140530193531) do

  create_table "contracts", force: true do |t|
    t.integer  "contractor_id"
    t.integer  "volunteer_id"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id"
    t.boolean  "dropped_out"
    t.boolean  "complete"
    t.boolean  "incomplete"
    t.boolean  "work_submitted"
  end

  create_table "conversations", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "volunteer_application_id"
    t.integer  "contract_id"
  end

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
    t.string   "state_abbreviation"
    t.text     "goal"
    t.string   "contact_number"
    t.string   "contact_email"
    t.string   "budget"
  end

  create_table "private_messages", force: true do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.string   "subject"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id"
    t.integer  "conversation_id"
  end

  create_table "project_users", force: true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
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

  create_table "user_conversations", force: true do |t|
    t.integer  "user_id"
    t.integer  "conversation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.string   "time_zone"
    t.text     "bio"
    t.string   "contact_reason"
    t.string   "organization_role"
    t.boolean  "nonprofit"
    t.string   "type"
    t.string   "user_group"
  end

  create_table "volunteer_applications", force: true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.boolean  "accepted"
    t.boolean  "rejected"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "applicant_id"
    t.integer  "administrator_id"
  end

end
>>>>>>> 12c328c120bc22fe35cdad022a62ce4ad3e62818
