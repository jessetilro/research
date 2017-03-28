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

ActiveRecord::Schema.define(version: 20170328073218) do

  create_table "participations", id: false, force: :cascade do |t|
    t.integer "project_id", null: false
    t.integer "user_id",    null: false
    t.index ["project_id"], name: "index_participations_on_project_id"
    t.index ["user_id"], name: "index_participations_on_user_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "reviews", force: :cascade do |t|
    t.integer  "rating"
    t.text     "comment"
    t.integer  "user_id"
    t.integer  "source_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["source_id"], name: "index_reviews_on_source_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "sources", force: :cascade do |t|
    t.string   "title"
    t.text     "authors"
    t.integer  "year"
    t.text     "url"
    t.text     "abstract"
    t.integer  "user_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.integer  "document_file_size"
    t.datetime "document_updated_at"
    t.text     "search_query"
    t.string   "search_database"
    t.text     "keywords"
    t.integer  "stars_count",           default: 0
    t.integer  "bibtex_type",           default: 0
    t.string   "bibtex_key"
    t.string   "isbn"
    t.string   "doi"
    t.text     "editors"
    t.string   "subtitle"
    t.string   "shorttitle"
    t.integer  "month"
    t.string   "publisher"
    t.string   "institution"
    t.string   "organization"
    t.text     "address"
    t.string   "school"
    t.string   "edition"
    t.string   "series"
    t.integer  "chapter"
    t.string   "pages"
    t.string   "journal"
    t.integer  "number"
    t.integer  "volume"
    t.text     "note"
    t.integer  "project_id"
    t.index ["project_id"], name: "index_sources_on_project_id"
    t.index ["user_id"], name: "index_sources_on_user_id"
  end

  create_table "stars", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "source_id",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["source_id"], name: "index_stars_on_source_id"
    t.index ["user_id"], name: "index_stars_on_user_id"
  end

  create_table "taggings", id: false, force: :cascade do |t|
    t.integer "source_id", null: false
    t.integer "tag_id",    null: false
    t.index ["source_id"], name: "index_taggings_on_source_id"
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "color"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "project_id"
    t.index ["project_id"], name: "index_tags_on_project_id"
  end

  create_table "users", force: :cascade do |t|
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
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "role",                   default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
