# frozen_string_literal: true

module Validation
  class ColorCodeValidator
    class << self
      def validate(color_code:)
        hex_regex = /\A#?([A-Fa-f0-9]{3}|[A-Fa-f0-9]{6})\z/

        if color_code.nil? || !color_code.match?(hex_regex)
          return Utility::Result.failure(error: 'Der Farbcode ist Invalide.')
        end

        Utility::Result.ok
      end
    end
  end
end
