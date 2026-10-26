require "test_helper"
require "stringio"
require "zlib"
require "json"
require "tempfile"

class Scryfall::CardImporterTest < ActiveSupport::TestCase
  def bulk_file(*cards)
    io = StringIO.new
    gz = Zlib::GzipWriter.new(io)
    cards.each { |card| gz.puts(card.to_json) }
    gz.close

    file = Tempfile.new([ "default-cards", ".jsonl.gz" ], binmode: true)
    file.write(io.string)
    file.flush
    file
  end

  def card_json(id:, faces: nil)
    {
      "object" => "card", "id" => id, "oracle_id" => SecureRandom.uuid, "name" => "Delver of Secrets",
      "lang" => "en", "layout" => faces ? "transform" : "normal", "set" => "isd", "set_name" => "Innistrad",
      "set_type" => "expansion", "collector_number" => "51", "rarity" => "common", "released_at" => "2011-09-30",
      "cmc" => 1.0, "color_identity" => [ "U" ], "keywords" => [], "multiverse_ids" => [ 1 ], "games" => [ "paper" ],
      "finishes" => [ "nonfoil", "foil" ], "border_color" => "black", "frame" => "2015", "image_status" => "highres_scan",
      "image_updated_at" => "2026-01-01T00:00:00Z", "booster" => true, "digital" => false, "foil" => true,
      "nonfoil" => true, "full_art" => false, "highres_image" => true, "oversized" => false, "promo" => false,
      "reprint" => false, "story_spotlight" => false, "textless" => false, "variation" => false,
      "reserved" => false, "game_changer" => false,
      "legalities" => { "modern" => "legal", "vintage" => "not_legal" },
      "prices" => { "usd" => "0.62", "usd_foil" => nil, "usd_etched" => nil, "eur" => "0.40", "eur_foil" => nil,
                    "eur_etched" => nil, "tix" => "0.03" },
      "all_parts" => [
        { "object" => "related_card", "id" => "11111111-1111-1111-1111-111111111111", "component" => "token",
          "name" => "Insect", "type_line" => "Token Creature — Insect", "uri" => "https://api.scryfall.com/x" }
      ],
      "card_faces" => faces
    }.compact
  end

  test "imports cards with faces, related cards, legalities and prices" do
    faces = [
      { "name" => "Delver of Secrets", "mana_cost" => "{U}", "type_line" => "Creature — Human Wizard",
        "colors" => [ "U" ], "image_uris" => { "normal" => "https://example.com/front.jpg" } },
      { "name" => "Insectile Aberration", "type_line" => "Creature — Insect", "colors" => [ "U" ],
        "image_uris" => { "normal" => "https://example.com/back.jpg" } }
    ]
    file = bulk_file(card_json(id: "22222222-2222-2222-2222-222222222222", faces: faces))

    count = Scryfall::CardImporter.new(file.path).import!

    assert_equal 1, count
    card = Card.find_by!(scryfall_id: "22222222-2222-2222-2222-222222222222")
    assert_equal Date.new(2011, 9, 30), card.released_at
    assert_equal [ "U" ], card.color_identity
    assert_equal [ "Delver of Secrets", "Insectile Aberration" ], card.faces.map(&:name)
    assert_equal "https://example.com/back.jpg", card.faces.last.image_uris["normal"]
    assert_equal "token", card.related_cards.sole.component
    assert_equal "legal", card.legalities.find_by!(format: "modern").legality
    assert_equal BigDecimal("0.62"), card.price.usd
    assert_nil card.price.usd_foil
  ensure
    file&.close!
  end

  test "re-importing does not duplicate rows" do
    file = bulk_file(card_json(id: "33333333-3333-3333-3333-333333333333"))

    Scryfall::CardImporter.new(file.path).import!
    assert_no_difference [ -> { Card.count }, -> { CardLegality.count }, -> { CardPrice.count }, -> { CardRelatedCard.count } ] do
      Scryfall::CardImporter.new(file.path).import!
    end
  ensure
    file&.close!
  end
end
