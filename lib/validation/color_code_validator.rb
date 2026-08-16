# frozen_string_literal: true

module Validation
  class ColorCodeValidator
    include Translations::Translatable

    def initialize(server_service:)
      @server_service = server_service
    end

    def validate(color_code:)
      hex_regex = /\A#?([A-Fa-f0-9]{3}|[A-Fa-f0-9]{6})\z/

      if color_code.nil? || !color_code.match?(hex_regex)
        return Utility::Result.failure(error: t('validation.color_code_validator.color_code_invalid'))
      end

      Utility::Result.ok
    end

    private

    attr_reader :server_service
  end
end
