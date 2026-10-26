class CreateCardRelatedCards < ActiveRecord::Migration[8.1]
  def change
    create_table :card_related_cards do |t|
      t.references :card, null: false, foreign_key: true
      t.string :related_scryfall_id, null: false
      t.string :component, null: false
      t.string :name, null: false
      t.string :type_line
      t.string :uri

      t.timestamps
    end

    add_index :card_related_cards, :related_scryfall_id
  end
end
