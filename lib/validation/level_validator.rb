# frozen_string_literal: true

module Validation
  class LevelValidator
    MIN_LEVEL = 0
    MAX_POSSIBLE_LEVEL = 100_000

    include Translations::Translatable

    def initialize(server_service:)
      @server_service = server_service
    end

    def validate_text_level(level:)
      if level < MIN_LEVEL
        return Utility::Result.failure(error: t('validation.level_validator.not_higher_than_min_level',
                                                { min_level: MIN_LEVEL }))
      end

      if level > preferences_repository.max_text_level
        return Utility::Result.failure(error: t('validation.level_validator.level_must_be_below_max_level'))
      end

      Utility::Result.ok
    end

    def validate_max_level_setting(level:)
      if level.negative?
        return Utility::Result.failure(error: t('validation.level_validator.max_level_must_be_positive'))
      end

      if level > MAX_POSSIBLE_LEVEL
        return Utility::Result.failure(error: t('validation.level_validator.max_level_must_be_below_100k'))
      end

      Utility::Result.ok
    end

    private

    attr_reader :server_service

    def preferences_repository
      @preferences_repository ||= Repositories::PreferencesRepository.new(server_id: server_service.server.id)
    end
  end
end
