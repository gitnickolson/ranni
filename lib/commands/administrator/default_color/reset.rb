# frozen_string_literal: true

module Commands
  module Administrator
    module DefaultColor
      class Reset < Subcommand
        NAME = :reset
        DESCRIPTION = 'Setze die Standardfarbe für den Bot zurück'
        DEFAULT_COLOR_CODE = '8a43ff'

        private

        def command_action
          preferences_repository.update_server_color(color_code: DEFAULT_COLOR_CODE)
          transmitter.response(event:,
                               text: t(
                                 'commands.administrator.default_color.color_successfully_reset',
                                 { color_code: DEFAULT_COLOR_CODE }
                               ))
        end

        def preferences_repository
          Repositories::PreferencesRepository.new(server_id:)
        end
      end
    end
  end
end
