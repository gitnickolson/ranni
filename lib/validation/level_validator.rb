# frozen_string_literal: true

module Validation
  class LevelValidator
    MIN_LEVEL = 0
    MAX_POSSIBLE_LEVEL = 100_000

    def initialize(server_service:)
      @server_service = server_service
    end

    def validate_text_level(level:)
      return Utility::Result.failure(error: "Das Level muss mindestens #{MIN_LEVEL} betragen.") if level < MIN_LEVEL

      if level > preferences_repository.max_text_level
        return Utility::Result.failure(error: 'Das Level darf nicht höher als das maximale Server-Level sein.')
      end

      Utility::Result.ok
    end

    def validate_max_level_setting(level:)
      return Utility::Result.failure(error: 'Das maximale Level darf nicht negativ sein.') if level.negative?

      if level > MAX_POSSIBLE_LEVEL
        return Utility::Result.failure(error: 'Das maximale Level darf 100.000 nicht überschreiten.')
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
