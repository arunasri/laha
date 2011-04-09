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

ActiveRecord::Schema.define(:version => 20110403191152) do

  create_table "channels", :force => true do |t|
    t.string   "name"
    t.string   "language"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "show_association_name"
  end

  create_table "crons", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "emailtbs", :force => true do |t|
    t.datetime "sent_at"
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feeds", :force => true do |t|
    t.string   "name"
    t.boolean  "approved",           :default => false
    t.integer  "default_channel_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "processed",          :default => false
  end

  create_table "shows", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "genre"
    t.string   "cast"
    t.string   "director"
    t.string   "wiki_url"
    t.date     "started_on"
    t.integer  "year"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "language"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider"
    t.string   "uid"
    t.boolean  "admin",      :default => false
  end

  create_table "videos", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "youtube_id"
    t.datetime "published_at"
    t.boolean  "approved",     :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "deleted",      :default => false, :null => false
    t.integer  "channel_id"
    t.string   "quality"
    t.string   "language"
    t.integer  "show_id"
    t.integer  "feed_id"
    t.string   "category"
    t.text     "keywords"
    t.integer  "duration"
    t.float    "rating"
    t.integer  "view_count"
    t.boolean  "racy",         :default => false
    t.string   "kind"
  end

  create_table "wiki_pages", :force => true do |t|
    t.text     "data"
    t.string   "url"
    t.string   "language"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
