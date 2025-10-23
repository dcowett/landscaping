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

ActiveRecord::Schema[8.0].define(version: 2025_10_23_092729) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "addresses", force: :cascade do |t|
    t.integer "street_number"
    t.string "street_name"
    t.string "zip_code"
    t.string "neighborhood"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "land_use_desc"
    t.string "subdivision_name"
    t.string "owner_name_line1"
    t.string "owner_name_line2"
    t.integer "user_id"
    t.index ["street_number", "street_name"], name: "index_addresses_on_street", unique: true
    t.index ["user_id"], name: "index_addresses_on_user_id"
  end

  create_table "notes", force: :cascade do |t|
    t.string "code"
    t.string "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "property_id", null: false
    t.index ["property_id"], name: "index_notes_on_property_id"
  end

  create_table "pins", force: :cascade do |t|
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["user_id"], name: "index_pins_on_user_id"
  end

  create_table "properties", force: :cascade do |t|
    t.integer "parid"
    t.string "situs_address"
    t.string "situs_postal_city"
    t.string "situs_postal_zip"
    t.string "land_use_code"
    t.string "land_use_desc"
    t.string "homestead_indicator"
    t.string "tax_district"
    t.date "last_sale_date"
    t.string "last_sale_vori"
    t.string "last_sale_qualified"
    t.decimal "last_sale_price"
    t.float "land_acreage"
    t.integer "bldg1_year_built"
    t.integer "bldgs_sqft_unroof"
    t.string "swimming_pool"
    t.string "community_dev_dist"
    t.string "cra_name"
    t.string "neighborhood_code"
    t.string "neighborhood_name"
    t.string "subdivision_code"
    t.string "subdivision_name"
    t.decimal "just_value"
    t.decimal "county_assessed_value"
    t.decimal "county_exempt_value"
    t.decimal "county_taxable_value"
    t.string "owner_name_line1"
    t.string "owner_name_line2"
    t.string "mailing_address_line1"
    t.string "mailing_address_line2"
    t.string "mailing_city"
    t.string "mailing_state"
    t.string "mailing_postal_code"
    t.string "mailing_country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "bldgs_sqft_living"
    t.index ["situs_address"], name: "index_properties_on_situs_address", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "notes", "properties"
end
