# frozen_string_literal: true

require 'httparty'

module Clients
  class CataasClient
    ENDPOINT = 'https://cataas.com/cat'
    TIMEOUT = 5

    class << self
      def random_cat_id
        response = HTTParty.get("#{ENDPOINT}?json=true", timeout: TIMEOUT)
        return unless response.success?

        response.parsed_response['id'] || response.parsed_response['_id']
      rescue StandardError => e
        Utility::Logger.instance.error(message: "Cataas request failed: #{e.class}: #{e.message}")
        nil
      end
    end
  end
end
