# frozen_string_literal: true

module Commands
  module Administrator
    module DefaultColor
      class Change < Subcommand
        NAME = :change
        DESCRIPTION = 'Verändere die Standardfarbe von Anzeigen des Bots'

        def self.register(discordrb_parent_command:)
          discordrb_parent_command.subcommand(NAME, DESCRIPTION) do |subcommand|
            subcommand.string('farbcode', 'Gib die Farbe als Hexcode an (z.B. FF3321)', required: true)
          end
        end

        private

        def command_action
          color_code = event.options['farbcode']

          result = validate_color_code(color_code)
          return transmitter.error_response(event:, text: result.value) if result.failure?

          preferences_repository.update_server_color(color_code:)
          transmitter.response(event:,
                               text: t('commands.administrator.default_color.color_successfully_set',
                                       { color_code: }))
        end

        def validate_color_code(color_code)
          color_code_validator.validate(color_code:)
        end

        def color_code_validator
          @color_code_validator ||= Validation::ColorCodeValidator.new(server_service:)
        end

        def preferences_repository
          @preferences_repository ||= Repositories::PreferencesRepository.new(server_id: server.id)
        end
      end
    end
  end
end
