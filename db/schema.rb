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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101025075938) do

  create_table "auctions", :force => true do |t|
    t.date     "adate"
    t.string   "tmk"
    t.string   "paddress1"
    t.string   "paddress2"
    t.string   "paddress3"
    t.string   "pcity"
    t.string   "pstate"
    t.string   "pzip"
    t.string   "punit"
    t.string   "aoao"
    t.string   "fs"
    t.string   "caddress1"
    t.string   "caddress2"
    t.string   "ccity"
    t.string   "island"
    t.string   "judicial"
    t.datetime "oh1date"
    t.datetime "oh2date"
    t.string   "ts"
    t.string   "lfname"
    t.string   "lfcontact"
    t.string   "lfphone"
    t.string   "lfemail"
    t.string   "lender"
    t.string   "docnumber"
    t.text     "adtext"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rejects", :force => true do |t|
    t.text     "adtext"
    t.integer  "doc_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
