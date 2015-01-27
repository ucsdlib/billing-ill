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

ActiveRecord::Schema.define(version: 20150126235658) do

  create_table "funds", force: :cascade do |t|
    t.string   "program_code"
    t.string   "org_code"
    t.string   "index_code"
    t.string   "fund_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recharges", force: :cascade do |t|
    t.decimal  "charge",        precision: 8, scale: 2
    t.integer  "number_copies"
    t.string   "status"
    t.text     "notes"
    t.datetime "submitted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
