require "zlib"
require "json"

module Scryfall
  # Streams a Scryfall bulk-data file (gzipped JSONL, one Card object per line)
  # into the cards, card_faces, card_related_cards, card_legalities and card_prices tables.
  #
  # Re-running is safe: cards are upserted by scryfall_id and child rows are rebuilt for each batch.
  class CardImporter
    BATCH_SIZE = 500
    INSERT_CHUNK_SIZE = 1_000

    CARD_COLUMNS = (Card.column_names - %w[id created_at updated_at]).freeze
    FACE_COLUMNS = (CardFace.column_names - %w[id card_id position created_at updated_at]).freeze
    PRICE_COLUMNS = %w[usd usd_foil usd_etched eur eur_foil eur_etched tix].freeze

    def initialize(path)
      @path = path
    end

    # Yields the running total after each batch so callers can report progress.
    def import!
      imported = 0

      Zlib::GzipReader.open(@path) do |gz|
        gz.each_line.each_slice(BATCH_SIZE) do |lines|
          cards = lines.map { |line| JSON.parse(line) }
          import_batch(cards)
          imported += cards.size
          yield imported if block_given?
        end
      end

      imported
    end

    private

    def import_batch(cards)
      ActiveRecord::Base.transaction do
        Card.upsert_all(cards.map { |data| card_attributes(data) }, unique_by: :scryfall_id)

        ids_by_scryfall_id = Card.where(scryfall_id: cards.map { |data| data["id"] }).pluck(:scryfall_id, :id).to_h
        card_ids = ids_by_scryfall_id.values

        CardFace.where(card_id: card_ids).delete_all
        CardRelatedCard.where(card_id: card_ids).delete_all
        CardLegality.where(card_id: card_ids).delete_all
        CardPrice.where(card_id: card_ids).delete_all

        faces, related, legalities, prices = [], [], [], []

        cards.each do |data|
          card_id = ids_by_scryfall_id.fetch(data["id"])
          faces.concat(face_rows(data, card_id))
          related.concat(related_rows(data, card_id))
          legalities.concat(legality_rows(data, card_id))
          prices << price_row(data, card_id) if data["prices"]
        end

        insert_in_chunks(CardFace, faces)
        insert_in_chunks(CardRelatedCard, related)
        insert_in_chunks(CardLegality, legalities)
        insert_in_chunks(CardPrice, prices)
      end
    end

    def card_attributes(data)
      attributes = CARD_COLUMNS.index_with { |column| data[column] }
      attributes["scryfall_id"] = data["id"]

      preview = data["preview"] || {}
      attributes["preview_previewed_at"] = preview["previewed_at"]
      attributes["preview_source_uri"] = preview["source_uri"]
      attributes["preview_source"] = preview["source"]

      attributes
    end

    def face_rows(data, card_id)
      Array(data["card_faces"]).each_with_index.map do |face, position|
        FACE_COLUMNS.index_with { |column| face[column] }.merge("card_id" => card_id, "position" => position)
      end
    end

    def related_rows(data, card_id)
      Array(data["all_parts"]).map do |part|
        {
          "card_id" => card_id,
          "related_scryfall_id" => part["id"],
          "component" => part["component"],
          "name" => part["name"],
          "type_line" => part["type_line"],
          "uri" => part["uri"]
        }
      end
    end

    def legality_rows(data, card_id)
      data.fetch("legalities", {}).map do |format, legality|
        { "card_id" => card_id, "format" => format, "legality" => legality }
      end
    end

    def price_row(data, card_id)
      PRICE_COLUMNS.index_with { |column| data["prices"][column] }.merge("card_id" => card_id)
    end

    def insert_in_chunks(model, rows)
      rows.each_slice(INSERT_CHUNK_SIZE) { |chunk| model.insert_all(chunk) }
    end
  end
end
