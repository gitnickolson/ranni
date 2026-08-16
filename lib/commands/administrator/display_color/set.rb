# frozen_string_literal: true

module Commands
  module Administrator
    module DisplayColor
      class Set < Subcommand
        NAME = :set
        DESCRIPTION = 'Change the default color that the bot uses for displays'
        PARAMETERS = [{ type: :string, name: :color_code, required: true,
                        description: 'Enter the Hexcode of the desired color (e.g. FF3321)' }].freeze

        private

        def command_action
          color_code = event.options['color_code']

          result = validate_color_code(color_code)
          return transmitter.error_response(event:, text: result.value) if result.failure?

          preferences_repository.update_server_color(color_code:)
          transmitter.response(event:,
                               text: t('commands.administrator.display_color.set.color_successfully_set',
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
