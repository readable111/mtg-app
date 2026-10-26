namespace :scryfall do
  desc "Import Scryfall Default Cards bulk data. Pass FILE=path/to/default-cards.jsonl.gz to skip the download."
  task import_default_cards: :environment do
    path = ENV["FILE"].presence ||
      Scryfall::BulkDownloader.new("default-cards", Rails.root.join("tmp/scryfall/default-cards.jsonl.gz")).download!

    started = Time.current
    total = Scryfall::CardImporter.new(path).import! do |count|
      print "\rImported #{count} cards"
    end
    puts "\nDone: #{total} cards in #{(Time.current - started).round(1)}s (#{Card.count} cards in database)"
  end
end
