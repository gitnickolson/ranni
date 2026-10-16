# frozen_string_literal: true

require 'tzinfo'

module Validation
  class TimezoneValidator
    include Translations::Translatable

    def initialize(server_service:)
      @server_service = server_service
    end

    def validate_timezone_string(timezone:)
      return Utility::Result.ok if TZInfo::Timezone.all_identifiers.include?(timezone)

      Utility::Result.failure(error: t('validation.timezone_validator.invalid_timezone_string', { timezone: }))
    end

    private

    attr_reader :server_service
  end
end
