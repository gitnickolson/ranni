# frozen_string_literal: true

module Commands
  module Administrator
    module MaxVoiceLevel
      class Set < Subcommand
        NAME = :set
        DESCRIPTION = 'Set the maximum voice level'
        PARAMETERS = [{ type: :integer, name: :level, required: true,
                        description: 'Choose the new maximum level' }].freeze

        private

        def command_action
          level = event.options['level'].to_i

          result = level_validator.validate_max_level_setting(level:)
          return transmitter.error_response(event:, text: result.value) if result.failure?

          preferences_repository.update_max_voice_level(level:)
          transmitter.response(event:,
                               text: t('commands.administrator.max_voice_level.set.max_level_successfully_set',
                                       { level: }))
        end

        def level_validator
          @level_validator ||= Validation::LevelValidator.new(server_service:)
        end

        def preferences_repository
          @preferences_repository ||= Repositories::PreferencesRepository.new(server_id: server.id)
        end
      end
    end
  end
end
