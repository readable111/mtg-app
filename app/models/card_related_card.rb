# A card closely related to another card (token, meld part, combo piece, ...).
# https://scryfall.com/docs/api/cards#related-card-objects
class CardRelatedCard < ApplicationRecord
  COMPONENTS = %w[token meld_part meld_result combo_piece].freeze

  belongs_to :card

  validates :related_scryfall_id, :component, :name, presence: true
  validates :component, inclusion: { in: COMPONENTS }
end
