require "test_helper"

class CardTest < ActiveSupport::TestCase
  def valid_card_attributes
    {
      scryfall_id: SecureRandom.uuid,
      name: "Lightning Bolt",
      layout: "normal",
      lang: "en",
      set: "lea",
      set_name: "Limited Edition Alpha",
      collector_number: "161",
      rarity: "common"
    }
  end

  test "valid with required attributes" do
    assert Card.new(valid_card_attributes).valid?
  end

  test "requires scryfall_id to be unique" do
    attributes = valid_card_attributes
    Card.create!(attributes)

    duplicate = Card.new(attributes.merge(name: "Other"))
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:scryfall_id], "has already been taken"
  end

  test "destroying a card removes its children" do
    card = Card.create!(valid_card_attributes)
    card.legalities.create!(format: "modern", legality: "legal")
    card.create_price!(usd: 1.5)

    assert_difference -> { CardLegality.count }, -1 do
      assert_difference -> { CardPrice.count }, -1 do
        card.destroy!
      end
    end
  end
end
