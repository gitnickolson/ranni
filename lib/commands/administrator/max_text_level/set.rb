# frozen_string_literal: true

module Commands
  module Administrator
    module MaxTextLevel
      class Set < Subcommand
        NAME = :set
        DESCRIPTION = 'Setze das maximale Text-level'

        def self.register(discordrb_parent_command:)
          discordrb_parent_command.subcommand(NAME, DESCRIPTION) do |subcommand|
            subcommand.integer('level', 'Das neue Level-Maximum.', required: true)
          end
        end

        private

        def command_action
          level = event.options['level'].to_i

          result = level_validator.validate_max_level_setting(level:)
          return transmitter.error_response(event:, text: result.value) if result.failure?

          preferences_repository.update_max_text_level(level:)
          transmitter.response(event:, text: "Maximales Text-Level erfolgreich auf #{level} gesetzt.")
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
