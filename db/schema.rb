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

ActiveRecord::Schema.define(version: 20160724172843) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contacts", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "email",      null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_contacts_on_user_id", using: :btree
  end

  create_table "custom_field_values", force: :cascade do |t|
    t.string   "value"
    t.integer  "contact_id",         null: false
    t.integer  "custom_field_id",    null: false
    t.integer  "drop_down_value_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["contact_id", "custom_field_id"], name: "index_custom_field_values_on_contact_id_and_custom_field_id", unique: true, using: :btree
    t.index ["custom_field_id"], name: "index_custom_field_values_on_custom_field_id", using: :btree
    t.index ["drop_down_value_id"], name: "index_custom_field_values_on_drop_down_value_id", using: :btree
  end

  create_table "custom_fields", force: :cascade do |t|
    t.string   "field_name", null: false
    t.string   "type",       null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_custom_fields_on_user_id", using: :btree
  end

  create_table "drop_down_values", force: :cascade do |t|
    t.string   "value",           null: false
    t.integer  "custom_field_id", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["custom_field_id"], name: "index_drop_down_values_on_custom_field_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",            null: false
    t.string   "email",           null: false
    t.string   "password_digest", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_foreign_key "contacts", "users"
  add_foreign_key "custom_field_values", "contacts"
  add_foreign_key "custom_field_values", "custom_fields"
  add_foreign_key "custom_field_values", "drop_down_values"
  add_foreign_key "custom_fields", "users"
  add_foreign_key "drop_down_values", "custom_fields"
end
