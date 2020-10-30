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

ActiveRecord::Schema.define(version: 20180315222214) do

  create_table "ingredients", force: :cascade do |t|
    t.string "name"
    t.boolean "base"
    t.boolean "caffeine_free"
    t.boolean "vegan"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "kombuchas", force: :cascade do |t|
    t.string "name"
    t.string "fizziness_level"
  end

  create_table "recipe_items", force: :cascade do |t|
    t.integer "kombucha_id"
    t.integer "ingredient_id"
    t.integer "amount"
    t.index ["ingredient_id"], name: "index_recipe_items_on_ingredient_id"
    t.index ["kombucha_id"], name: "index_recipe_items_on_kombucha_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
