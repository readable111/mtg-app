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

ActiveRecord::Schema[8.1].define(version: 2026_10_21_184122) do
  create_table "card_faces", force: :cascade do |t|
    t.integer "card_id", null: false
    t.integer "position", null: false
    t.string "name", null: false
    t.string "layout"
    t.string "oracle_id"
    t.decimal "cmc", precision: 6, scale: 2
    t.string "mana_cost"
    t.string "type_line"
    t.text "oracle_text"
    t.json "colors"
    t.json "color_indicator"
    t.string "power"
    t.string "toughness"
    t.string "loyalty"
    t.string "defense"
    t.string "watermark"
    t.json "image_uris"
    t.string "illustration_id"
    t.string "artist"
    t.string "artist_id"
    t.text "flavor_text"
    t.string "flavor_name"
    t.string "printed_name"
    t.text "printed_text"
    t.string "printed_type_line"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id", "position"], name: "index_card_faces_on_card_id_and_position", unique: true
    t.index ["card_id"], name: "index_card_faces_on_card_id"
  end

  create_table "card_legalities", force: :cascade do |t|
    t.integer "card_id", null: false
    t.string "format", null: false
    t.string "legality", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id", "format"], name: "index_card_legalities_on_card_id_and_format", unique: true
    t.index ["card_id"], name: "index_card_legalities_on_card_id"
  end

  create_table "card_prices", force: :cascade do |t|
    t.integer "card_id", null: false
    t.decimal "usd", precision: 10, scale: 2
    t.decimal "usd_foil", precision: 10, scale: 2
    t.decimal "usd_etched", precision: 10, scale: 2
    t.decimal "eur", precision: 10, scale: 2
    t.decimal "eur_foil", precision: 10, scale: 2
    t.decimal "eur_etched", precision: 10, scale: 2
    t.decimal "tix", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id"], name: "index_card_prices_on_card_id", unique: true
  end

  create_table "card_related_cards", force: :cascade do |t|
    t.integer "card_id", null: false
    t.string "related_scryfall_id", null: false
    t.string "component", null: false
    t.string "name", null: false
    t.string "type_line"
    t.string "uri"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id"], name: "index_card_related_cards_on_card_id"
    t.index ["related_scryfall_id"], name: "index_card_related_cards_on_related_scryfall_id"
  end

  create_table "cards", force: :cascade do |t|
    t.string "scryfall_id", null: false
    t.string "oracle_id"
    t.integer "arena_id"
    t.integer "mtgo_id"
    t.integer "mtgo_foil_id"
    t.json "multiverse_ids"
    t.string "resource_id"
    t.integer "tcgplayer_id"
    t.integer "tcgplayer_etched_id"
    t.integer "cardmarket_id"
    t.string "uri"
    t.string "scryfall_uri"
    t.string "prints_search_uri"
    t.string "rulings_uri"
    t.json "purchase_uris"
    t.json "related_uris"
    t.string "name", null: false
    t.string "layout", null: false
    t.decimal "cmc", precision: 6, scale: 2
    t.json "color_identity"
    t.json "color_indicator"
    t.json "colors"
    t.json "produced_mana"
    t.json "keywords"
    t.string "mana_cost"
    t.string "type_line"
    t.text "oracle_text"
    t.string "power"
    t.string "toughness"
    t.string "loyalty"
    t.string "defense"
    t.string "hand_modifier"
    t.string "life_modifier"
    t.integer "edhrec_rank"
    t.integer "penny_rank"
    t.boolean "game_changer", default: false, null: false
    t.boolean "reserved", default: false, null: false
    t.string "lang", null: false
    t.string "set", null: false
    t.string "set_id"
    t.string "set_name", null: false
    t.string "set_type"
    t.string "scryfall_set_uri"
    t.string "set_uri"
    t.string "set_search_uri"
    t.string "collector_number", null: false
    t.string "rarity", null: false
    t.date "released_at"
    t.string "border_color"
    t.string "frame"
    t.json "frame_effects"
    t.string "security_stamp"
    t.string "watermark"
    t.string "image_status"
    t.datetime "image_updated_at"
    t.json "image_uris"
    t.string "illustration_id"
    t.string "card_back_id"
    t.json "games"
    t.json "finishes"
    t.json "promo_types"
    t.string "variation_of"
    t.string "artist"
    t.json "artist_ids"
    t.json "attraction_lights"
    t.string "flavor_name"
    t.text "flavor_text"
    t.string "printed_name"
    t.text "printed_text"
    t.string "printed_type_line"
    t.boolean "booster", default: false, null: false
    t.boolean "digital", default: false, null: false
    t.boolean "foil", default: false, null: false
    t.boolean "nonfoil", default: false, null: false
    t.boolean "full_art", default: false, null: false
    t.boolean "highres_image", default: false, null: false
    t.boolean "oversized", default: false, null: false
    t.boolean "promo", default: false, null: false
    t.boolean "reprint", default: false, null: false
    t.boolean "story_spotlight", default: false, null: false
    t.boolean "textless", default: false, null: false
    t.boolean "variation", default: false, null: false
    t.boolean "content_warning"
    t.datetime "preview_previewed_at"
    t.string "preview_source"
    t.string "preview_source_uri"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_cards_on_name"
    t.index ["oracle_id"], name: "index_cards_on_oracle_id"
    t.index ["scryfall_id"], name: "index_cards_on_scryfall_id", unique: true
    t.index ["set", "collector_number"], name: "index_cards_on_set_and_collector_number"
    t.index ["set_id"], name: "index_cards_on_set_id"
  end

  add_foreign_key "card_faces", "cards"
  add_foreign_key "card_legalities", "cards"
  add_foreign_key "card_prices", "cards"
  add_foreign_key "card_related_cards", "cards"
end
