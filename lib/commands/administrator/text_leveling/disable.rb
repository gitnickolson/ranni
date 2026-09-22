# frozen_string_literal: true

module Commands
  module Administrator
    module TextLeveling
      class Disable < Subcommand
        NAME = :disable
        DESCRIPTION = 'Disable text leveling'

        private

        def command_action
          preferences_repository.set_text_leveling(enabled: false)
          transmitter.response(event:,
                               text:
                               t('commands.administrator.text_leveling.disable.text_leveling_successfully_disabled'))
        end

        def preferences_repository
          server_service.preferences_repository
        end
      end
    end
  end
end
