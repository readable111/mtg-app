require "net/http"
require "fileutils"
require "json"

module Scryfall
  # Downloads a Scryfall bulk data file (e.g. "default-cards") to disk.
  # See https://scryfall.com/docs/api/bulk-data
  class BulkDownloader
    API_URL = "https://api.scryfall.com/bulk-data".freeze
    USER_AGENT = "MtgApp/1.0".freeze

    def initialize(type, dest)
      @type = type
      @dest = dest
    end

    # Returns the destination path once the file is fully written.
    def download!
      meta = JSON.parse(get("#{API_URL}/#{@type}", "application/json"))
      puts "Downloading #{meta['name']} (#{meta['compressed_size']} bytes, updated #{meta['updated_at']})"

      FileUtils.mkdir_p(File.dirname(@dest))
      uri = URI(meta.fetch("jsonl_download_uri"))

      Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https") do |http|
        http.request(request(uri, "*/*")) do |response|
          raise "Download failed: #{response.code} #{response.message}" unless response.is_a?(Net::HTTPSuccess)

          File.open(@dest, "wb") { |file| response.read_body { |chunk| file.write(chunk) } }
        end
      end

      @dest
    end

    private

    def get(url, accept)
      uri = URI(url)
      response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https") { |http| http.request(request(uri, accept)) }
      raise "Request to #{url} failed: #{response.code} #{response.message}" unless response.is_a?(Net::HTTPSuccess)

      response.body
    end

    def request(uri, accept)
      Net::HTTP::Get.new(uri, "User-Agent" => USER_AGENT, "Accept" => accept)
    end
  end
end
