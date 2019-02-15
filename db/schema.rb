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

ActiveRecord::Schema.define(version: 2019_02_15_062515) do

  create_table "brands", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end


  create_table "categories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "ancestry"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ancestry"], name: "index_categories_on_ancestry"
  end

  create_table "creditcards", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.string "customer_token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_creditcards_on_user_id"
  end

  create_table "favorite_items", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_favorite_items_on_item_id"
    t.index ["user_id", "item_id"], name: "index_favorite_items_on_user_id_and_item_id", unique: true
    t.index ["user_id"], name: "index_favorite_items_on_user_id"
  end

  create_table "item_photos", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "image", null: false
    t.bigint "item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_item_photos_on_item_id"
  end

  create_table "items", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.text "comment", null: false
    t.integer "category_id", null: false
    t.integer "brand_id"
    t.boolean "shipping_fee", null: false
    t.integer "prefecture_id", null: false
    t.integer "days_to_ship", null: false
    t.integer "price", null: false
    t.integer "condition", null: false
    t.bigint "user_id", null: false
    t.boolean "closed", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_items_on_name"
    t.index ["user_id"], name: "index_items_on_user_id"
  end

  create_table "order_statuses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "purchaser_id"
    t.bigint "seller_id"
    t.integer "status", null: false
    t.bigint "item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_order_statuses_on_item_id"
    t.index ["purchaser_id"], name: "index_order_statuses_on_purchaser_id"
    t.index ["seller_id"], name: "index_order_statuses_on_seller_id"
  end

  create_table "point_records", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "point", null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_point_records_on_user_id"
  end

  create_table "profiles", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "phone", null: false
    t.integer "postal_code", null: false
    t.integer "prefecture_id", null: false
    t.string "city", null: false
    t.string "block", null: false
    t.string "building"
    t.bigint "user_id"
    t.text "comment"
    t.text "avatar"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "sns_credentials", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "uid"
    t.string "provider"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sns_credentials_on_user_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "last_name", null: false
    t.string "first_name", null: false
    t.string "last_name_kana", null: false
    t.string "first_name_kana", null: false
    t.integer "birth_y", null: false
    t.integer "birth_m", null: false
    t.integer "birth_d", null: false
    t.string "nickname", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "creditcards", "users"
  add_foreign_key "favorite_items", "items"
  add_foreign_key "favorite_items", "users"
  add_foreign_key "item_photos", "items"
  add_foreign_key "items", "users"
  add_foreign_key "order_statuses", "items"
  add_foreign_key "order_statuses", "users", column: "purchaser_id"
  add_foreign_key "order_statuses", "users", column: "seller_id"
  add_foreign_key "point_records", "users"
  add_foreign_key "profiles", "users"
end
