class CreateCardFaces < ActiveRecord::Migration[8.1]
  def change
    create_table :card_faces do |t|
      t.references :card, null: false, foreign_key: true
      t.integer :position, null: false

      t.string :name, null: false
      t.string :layout
      t.string :oracle_id
      t.decimal :cmc, precision: 6, scale: 2
      t.string :mana_cost
      t.string :type_line
      t.text :oracle_text
      t.json :colors
      t.json :color_indicator
      t.string :power
      t.string :toughness
      t.string :loyalty
      t.string :defense
      t.string :watermark
      t.json :image_uris
      t.string :illustration_id
      t.string :artist
      t.string :artist_id
      t.text :flavor_text
      t.string :flavor_name
      t.string :printed_name
      t.text :printed_text
      t.string :printed_type_line

      t.timestamps
    end

    add_index :card_faces, [ :card_id, :position ], unique: true
  end
end
