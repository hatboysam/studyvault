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

ActiveRecord::Schema.define(:version => 20111230042053) do

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "file_id"
    t.text     "content"
    t.integer  "rating"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "courses", :force => true do |t|
    t.string   "subject"
    t.integer  "course_code"
    t.integer  "school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "full_name"
  end

  create_table "downloads", :force => true do |t|
    t.integer  "user_id"
    t.integer  "upload_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schools", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "schools", ["name"], :name => "index_schools_on_name", :unique => true

  create_table "uploads", :force => true do |t|
    t.integer  "user_id",             :limit => 255
    t.string   "linked_file_name"
    t.string   "linked_content_type"
    t.integer  "linked_file_size"
    t.integer  "stars"
    t.integer  "ratings"
    t.string   "semester"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "professor"
    t.datetime "year"
    t.text     "description",                        :default => "No description given"
    t.integer  "school_id"
    t.integer  "course_id"
    t.string   "temp_coursename"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "encrypted_password"
    t.string   "pepper"
    t.string   "email"
    t.integer  "school_id"
    t.integer  "credits"
    t.integer  "stars"
    t.integer  "graduation"
    t.boolean  "admin",              :default => false
    t.boolean  "confirmed",          :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "stars_redeemed",     :default => 0
  end

end
