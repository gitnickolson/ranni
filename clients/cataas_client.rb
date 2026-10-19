# frozen_string_literal: true

module Clients
  class CataasClient
    class << self
      ENDPOINT = 'https://cataas.com/cat'

      def random_cat_id
        response = HTTParty.get("#{ENDPOINT}?json=true").parsed_response
        response['id'] || response['_id']
      end
    end
  end
end
