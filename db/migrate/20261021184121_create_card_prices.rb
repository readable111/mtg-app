class CreateCardPrices < ActiveRecord::Migration[8.1]
  def change
    create_table :card_prices do |t|
      t.references :card, null: false, foreign_key: true, index: { unique: true }
      t.decimal :usd, precision: 10, scale: 2
      t.decimal :usd_foil, precision: 10, scale: 2
      t.decimal :usd_etched, precision: 10, scale: 2
      t.decimal :eur, precision: 10, scale: 2
      t.decimal :eur_foil, precision: 10, scale: 2
      t.decimal :eur_etched, precision: 10, scale: 2
      t.decimal :tix, precision: 10, scale: 2

      t.timestamps
    end
  end
end
