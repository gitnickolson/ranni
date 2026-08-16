# frozen_string_literal: true

module Commands
  module Administrator
    module DisplayColor
      class Reset < Subcommand
        NAME = :reset
        DESCRIPTION = 'Reset the display color of the bot to default (8a43ff)'
        DEFAULT_COLOR_CODE = '8a43ff'

        private

        def command_action
          preferences_repository.update_server_color(color_code: DEFAULT_COLOR_CODE)
          transmitter.response(event:,
                               text: t(
                                 'commands.administrator.display_color.reset.color_successfully_reset',
                                 { color_code: DEFAULT_COLOR_CODE }
                               ))
        end

        def preferences_repository
          Repositories::PreferencesRepository.new(server_id: server.id)
        end
      end
    end
  end
end
