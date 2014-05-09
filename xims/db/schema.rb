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

ActiveRecord::Schema.define(version: 20140501194848) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "employees", force: true do |t|
    t.integer  "organization_id", null: false
    t.integer  "individual_id",   null: false
    t.integer  "workspace_id",    null: false
    t.integer  "occupation_id",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "incident_types", force: true do |t|
    t.string "name", null: false
  end

  create_table "incidents", force: true do |t|
    t.integer  "incident_type_id", null: false
    t.datetime "occurrence_date",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "individuals", force: true do |t|
    t.integer  "id_number",        null: false
    t.string   "first_name",       null: false
    t.string   "middle_name"
    t.string   "last_name",        null: false
    t.string   "second_last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "age"
  end

  create_table "medical_exams", force: true do |t|
    t.integer  "employee_id",     null: false
    t.datetime "expiration_date", null: false
    t.boolean  "active"
  end

  create_table "occupations", force: true do |t|
    t.string "name", null: false
  end

  create_table "organizations", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "risk_insurances", force: true do |t|
    t.integer  "employee_id",     null: false
    t.datetime "expiration_date", null: false
    t.boolean  "active"
  end

  create_table "training_employees", force: true do |t|
    t.integer  "training_id",  null: false
    t.integer  "employee_id",  null: false
    t.text     "observations"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "trainings", force: true do |t|
    t.integer  "organization_id", null: false
    t.integer  "responsible_id"
    t.integer  "trainer_id",      null: false
    t.integer  "training_type",   null: false
    t.datetime "training_date",   null: false
    t.integer  "training_hours",  null: false
    t.string   "topic",           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "uploads", force: true do |t|
    t.string   "sha1",              limit: 40
    t.string   "original_filename",            null: false
    t.integer  "filesize",                     null: false
    t.integer  "width"
    t.integer  "height"
    t.string   "url",                          null: false
    t.integer  "uploaded_by_id",               null: false
    t.integer  "uploadable_id"
    t.string   "uploadable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "employee_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "workspaces", force: true do |t|
    t.string "name", null: false
  end

end
