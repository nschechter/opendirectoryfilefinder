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

ActiveRecord::Schema.define(version: 20170515011155) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string  "username"
    t.string  "password_digest"
    t.boolean "admin"
  end

  create_table "open_dirs", force: :cascade do |t|
    t.string  "url"
    t.string  "root_url"
    t.string  "dir_type"
    t.text    "dir_links",  default: [],    array: true
    t.text    "file_links", default: [],    array: true
    t.boolean "scraped",    default: false
  end

end
