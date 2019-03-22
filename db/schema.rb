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

ActiveRecord::Schema.define(version: 2019_03_22_131647) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "fuzzystrmatch"
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.string "record_type", limit: 255, null: false
    t.decimal "record_id", null: false
    t.decimal "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "idx_37159_index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "idx_37159_index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", limit: 255, null: false
    t.string "filename", limit: 255, null: false
    t.string "content_type", limit: 255
    t.text "metadata"
    t.decimal "byte_size", null: false
    t.string "checksum", limit: 255, null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "idx_37168_index_active_storage_blobs_on_key", unique: true
  end

  create_table "participations", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "user_id", null: false
    t.datetime "last_used_at"
    t.datetime "created_at", default: "2017-02-27 19:54:00", null: false
    t.datetime "updated_at", default: "2017-02-27 19:54:00", null: false
    t.index ["project_id"], name: "idx_37183_index_participations_on_project_id"
    t.index ["user_id"], name: "idx_37183_index_participations_on_user_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name", limit: 255
    t.string "description", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "rating"
    t.text "comment"
    t.bigint "user_id"
    t.bigint "source_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["source_id"], name: "idx_37200_index_reviews_on_source_id"
    t.index ["user_id"], name: "idx_37200_index_reviews_on_user_id"
  end

  create_table "sources", force: :cascade do |t|
    t.string "title", limit: 255
    t.text "authors"
    t.bigint "year"
    t.text "url"
    t.text "abstract"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "search_query"
    t.string "search_database", limit: 255
    t.text "keywords"
    t.bigint "stars_count", default: 0
    t.bigint "bibtex_type", default: 0
    t.string "bibtex_key", limit: 255
    t.string "isbn", limit: 255
    t.string "doi", limit: 255
    t.text "editors"
    t.string "subtitle", limit: 255
    t.string "shorttitle", limit: 255
    t.bigint "month"
    t.string "publisher", limit: 255
    t.string "institution", limit: 255
    t.string "organization", limit: 255
    t.text "address"
    t.string "school", limit: 255
    t.string "edition", limit: 255
    t.string "series", limit: 255
    t.bigint "chapter"
    t.string "pages", limit: 255
    t.string "journal", limit: 255
    t.bigint "number"
    t.bigint "volume"
    t.text "note"
    t.bigint "project_id"
    t.index ["project_id"], name: "idx_37212_index_sources_on_project_id"
    t.index ["user_id"], name: "idx_37212_index_sources_on_user_id"
  end

  create_table "stars", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "source_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["source_id"], name: "idx_37223_index_stars_on_source_id"
    t.index ["user_id"], name: "idx_37223_index_stars_on_user_id"
  end

  create_table "taggings", id: false, force: :cascade do |t|
    t.bigint "source_id", null: false
    t.bigint "tag_id", null: false
    t.index ["source_id"], name: "idx_37227_index_taggings_on_source_id"
    t.index ["tag_id"], name: "idx_37227_index_taggings_on_tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", limit: 255
    t.text "description"
    t.string "color", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "project_id"
    t.index ["project_id"], name: "idx_37232_index_tags_on_project_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", limit: 255, default: "", null: false
    t.string "encrypted_password", limit: 255, default: "", null: false
    t.string "reset_password_token", limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.bigint "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip", limit: 255
    t.string "last_sign_in_ip", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name", limit: 255
    t.string "last_name", limit: 255
    t.bigint "role", default: 0
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "idx_37241_index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "idx_37241_index_users_on_reset_password_token", unique: true
  end

end
