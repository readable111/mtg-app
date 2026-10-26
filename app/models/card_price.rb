# Daily price snapshot for a card, from the `prices` object.
# Scryfall considers these stale after 24 hours; refresh before relying on them.
class CardPrice < ApplicationRecord
  belongs_to :card
end
