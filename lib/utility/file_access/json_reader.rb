# frozen_string_literal: true

require 'json'

module Utility
  module FileAccess
    class JsonReader
      class << self
        def call(filepath:)
          path = filepath.end_with?('.json') ? filepath : "#{filepath}.json"
          JSON.parse(File.read(path, encoding: 'UTF-8'), symbolize_names: true)
        end
      end
    end
  end
end
