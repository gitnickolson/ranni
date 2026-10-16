# frozen_string_literal: true

module Commands
  module Administrator
    module Timezone
      class Set < Subcommand
        NAME = :set
        DESCRIPTION = 'Set the bot timezone'
        PARAMETERS = [
          { type: :string, name: :timezone, required: true,
            description: 'Enter the new timezone (Case sensitive! Example: Europe/Berlin or Africa/Ceuta)' }
        ].freeze

        private

        def command_action
          timezone = event.options['timezone']

          timezone_validator = Validation::TimezoneValidator.new(server_service:)
          result = timezone_validator.validate_timezone_string(timezone:)

          return transmitter.error_response(event:, text: result.value) if result.failure?

          preferences_repository.set_timezone(timezone:)
          transmitter.response(event:,
                               text: t('commands.administrator.timezone.set.timezone_successfully_set',
                                       { timezone: }))
        end

        def preferences_repository
          server_service.preferences_repository
        end
      end
    end
  end
end
