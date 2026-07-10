# frozen_string_literal: true

require 'dotenv'

module Utility
  class EnvironmentFetcher
    class << self
      def postgres_url
        ENV.fetch('POSTGRES_URL')
      end

      def database_name
        ENV.fetch('POSTGRES_DB')
      end
    end
  end
end
