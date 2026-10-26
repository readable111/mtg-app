# Legality of a card in one play format, from the `legalities` object.
class CardLegality < ApplicationRecord
  LEGALITIES = %w[legal not_legal restricted banned].freeze

  belongs_to :card

  validates :format, presence: true, uniqueness: { scope: :card_id }
  validates :legality, inclusion: { in: LEGALITIES }
end
