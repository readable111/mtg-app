# One face of a multi-face card (split, flip, transform, modal DFC, etc.).
# https://scryfall.com/docs/api/cards#card-face-objects
class CardFace < ApplicationRecord
  belongs_to :card

  validates :position, presence: true, uniqueness: { scope: :card_id }
  validates :name, presence: true
end
