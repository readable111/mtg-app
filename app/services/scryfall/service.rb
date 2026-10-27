class Scryfall::Service
  API_URL = "https://api.scryfall.com/bulk-data".freeze
  USER_AGENT = "MtgApp/1.0".freeze

  def self.client
    @@client = Faraday.new(url: API_URL, headers: { "User-Agent": USER_AGENT })
  end

  def get
  end
end
