# frozen_string_literal: true

module Validation
  class LevelValidator
    DEFAULT_MAX_LEVEL = 250
    DEFAULT_MIN_LEVEL = 0
    MAX_NUMERIC_LEVEL = 100_000

    class << self
      def validate(level:)
        if level < DEFAULT_MIN_LEVEL
          return Utility::Result.failure(error: "Das Level muss mindestens #{DEFAULT_MIN_LEVEL} betragen.")
        end

        if level > DEFAULT_MAX_LEVEL
          return Utility::Result.failure(error: "Das Level darf maximal #{DEFAULT_MAX_LEVEL} betragen.")
        end

        Utility::Result.ok
      end

      def validate_max_level_setting(level:)
        return Utility::Result.failure(error: 'Das maximale Level darf nicht negativ sein.') if level.negative?

        if level > MAX_NUMERIC_LEVEL
          return Utility::Result.failure(error: 'Das maximale Level darf 100.000 nicht überschreiten.')
        end

        Utility::Result.ok
      end
    end
  end
end
