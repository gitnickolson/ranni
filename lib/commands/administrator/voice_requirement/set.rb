# frozen_string_literal: true

module Commands
  module Administrator
    module VoiceRequirement
      class Set < Subcommand
        NAME = :set
        DESCRIPTION = 'Set the minimum level needed to join voice chats'
        PARAMETERS = [{ type: :integer, name: :level, required: true,
                        description: 'Choose the new minimum level required to join voice chats' }].freeze

        private

        def command_action
          level = event.options['level']

          result = level_validator.validate_level(level:)
          return transmitter.error_response(event:, text: result.value) if result.failure?

          preferences_repository.set_voice_chat_level_requirement(level:)
          transmitter.response(event:, text:
          t('commands.administrator.voice_requirement.set.voice_requirement_successfully_set',
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
