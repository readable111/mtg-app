class CreateCards < ActiveRecord::Migration[8.1]
  def change
    create_table :cards do |t|
      # Identity and external IDs
      t.string :scryfall_id, null: false
      t.string :oracle_id
      t.integer :arena_id
      t.integer :mtgo_id
      t.integer :mtgo_foil_id
      t.json :multiverse_ids
      t.string :resource_id
      t.integer :tcgplayer_id
      t.integer :tcgplayer_etched_id
      t.integer :cardmarket_id

      # Links
      t.string :uri
      t.string :scryfall_uri
      t.string :prints_search_uri
      t.string :rulings_uri
      t.json :purchase_uris
      t.json :related_uris

      # Gameplay
      t.string :name, null: false
      t.string :layout, null: false
      t.decimal :cmc, precision: 6, scale: 2
      t.json :color_identity
      t.json :color_indicator
      t.json :colors
      t.json :produced_mana
      t.json :keywords
      t.string :mana_cost
      t.string :type_line
      t.text :oracle_text
      t.string :power
      t.string :toughness
      t.string :loyalty
      t.string :defense
      t.string :hand_modifier
      t.string :life_modifier
      t.integer :edhrec_rank
      t.integer :penny_rank
      t.boolean :game_changer, null: false, default: false
      t.boolean :reserved, null: false, default: false

      # Print
      t.string :lang, null: false
      t.string :set, null: false
      t.string :set_id
      t.string :set_name, null: false
      t.string :set_type
      t.string :scryfall_set_uri
      t.string :set_uri
      t.string :set_search_uri
      t.string :collector_number, null: false
      t.string :rarity, null: false
      t.date :released_at
      t.string :border_color
      t.string :frame
      t.json :frame_effects
      t.string :security_stamp
      t.string :watermark
      t.string :image_status
      t.datetime :image_updated_at
      t.json :image_uris
      t.string :illustration_id
      t.string :card_back_id
      t.json :games
      t.json :finishes
      t.json :promo_types
      t.string :variation_of
      t.string :artist
      t.json :artist_ids
      t.json :attraction_lights
      t.string :flavor_name
      t.text :flavor_text
      t.string :printed_name
      t.text :printed_text
      t.string :printed_type_line
      t.boolean :booster, null: false, default: false
      t.boolean :digital, null: false, default: false
      t.boolean :foil, null: false, default: false
      t.boolean :nonfoil, null: false, default: false
      t.boolean :full_art, null: false, default: false
      t.boolean :highres_image, null: false, default: false
      t.boolean :oversized, null: false, default: false
      t.boolean :promo, null: false, default: false
      t.boolean :reprint, null: false, default: false
      t.boolean :story_spotlight, null: false, default: false
      t.boolean :textless, null: false, default: false
      t.boolean :variation, null: false, default: false
      t.boolean :content_warning

      # Preview (flattened from the `preview` object)
      t.datetime :preview_previewed_at
      t.string :preview_source
      t.string :preview_source_uri

      t.timestamps
    end

    add_index :cards, :scryfall_id, unique: true
    add_index :cards, :oracle_id
    add_index :cards, :name
    add_index :cards, [ :set, :collector_number ]
    add_index :cards, :set_id
  end
end
