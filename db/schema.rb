# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_12_18_151415) do

  create_table "images", charset: "utf8mb4", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "series_id"
    t.integer "category"
    t.string "image_hash"
    t.integer "movie_id"
  end

  create_table "movies", charset: "utf8mb4", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.string "name_cn"
    t.text "description"
    t.integer "tmdb_id"
    t.integer "bgm_id"
    t.integer "poster_id"
    t.integer "backdrop_id"
    t.integer "logo_id"
  end

  create_table "onairseries", charset: "utf8mb4", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "series_id"
    t.integer "day"
    t.string "time"
    t.integer "status"
  end

  create_table "relationships", charset: "utf8mb4", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "staff_id"
    t.integer "series_id"
    t.integer "role"
  end

  create_table "series", charset: "utf8mb4", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.string "name_cn"
    t.text "description"
    t.integer "tmdb_id"
    t.integer "season"
    t.integer "status"
    t.integer "poster_id"
    t.integer "backdrop_id"
    t.integer "logo_id"
    t.integer "bgm_id"
    t.integer "year"
    t.integer "nsfw"
  end

  create_table "staffs", charset: "utf8mb4", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.string "name_cn"
  end

  create_table "streams", charset: "utf8mb4", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.string "link"
  end

  create_table "subscriptions", charset: "utf8mb4", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "series_id"
    t.string "rss_link"
    t.boolean "active"
  end

  create_table "subtitles", charset: "utf8mb4", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "zh_CN_hash"
    t.string "zh_TW_hash"
  end

  create_table "taggings", charset: "utf8mb4", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "tag_id"
    t.integer "series_id"
    t.integer "weight"
    t.integer "movie_id"
  end

  create_table "tags", charset: "utf8mb4", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.boolean "hidden", default: false
  end

  create_table "videos", charset: "utf8mb4", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.integer "episode"
    t.integer "series_id"
    t.string "video_hash"
    t.integer "subtitle"
    t.integer "movie_id"
  end

  create_table "wishes", charset: "utf8mb4", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "bgm_id"
    t.string "bgm_user"
  end

end
