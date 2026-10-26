class CreateCardLegalities < ActiveRecord::Migration[8.1]
  def change
    create_table :card_legalities do |t|
      t.references :card, null: false, foreign_key: true
      t.string :format, null: false
      t.string :legality, null: false

      t.timestamps
    end

    add_index :card_legalities, [ :card_id, :format ], unique: true
  end
end
