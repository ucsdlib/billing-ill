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

ActiveRecord::Schema.define(version: 20150428212808) do

  create_table "funds", force: :cascade do |t|
    t.string   "program_code"
    t.string   "org_code"
    t.string   "index_code"
    t.string   "fund_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
  end

  create_table "invoices", force: :cascade do |t|
    t.integer  "charge_cents"
    t.integer  "number_prints"
    t.string   "invoice_type"
    t.string   "status"
    t.text     "ill_numbers"
    t.datetime "submitted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "patron_id"
  end

  create_table "patrons", force: :cascade do |t|
    t.string   "email_address"
    t.string   "name"
    t.string   "ar_code"
    t.string   "address1"
    t.string   "address2"
    t.string   "address3"
    t.string   "address4"
    t.string   "city"
    t.string   "state"
    t.string   "zip1"
    t.string   "zip2"
    t.string   "country_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recharges", force: :cascade do |t|
    t.integer  "number_copies"
    t.string   "status"
    t.text     "notes"
    t.datetime "submitted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "fund_id"
    t.integer  "charge_cents"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",      default: ""
    t.string   "full_name",  default: ""
    t.string   "uid",        default: "", null: false
    t.string   "provider",   default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
