# A single Magic: The Gathering printing, mirroring the Scryfall Card object.
# https://scryfall.com/docs/api/cards
class Card < ApplicationRecord
  has_many :faces, -> { order(:position) }, class_name: "CardFace", dependent: :destroy
  has_many :related_cards, class_name: "CardRelatedCard", dependent: :destroy
  has_many :legalities, class_name: "CardLegality", dependent: :destroy
  has_one :price, class_name: "CardPrice", dependent: :destroy

  validates :scryfall_id, presence: true, uniqueness: true
  validates :name, :layout, :lang, :set, :set_name, :collector_number, :rarity, presence: true

  scope :in_set, ->(code) { where(set: code.downcase) }
end
