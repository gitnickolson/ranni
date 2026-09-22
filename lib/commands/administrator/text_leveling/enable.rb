# frozen_string_literal: true

module Commands
  module Administrator
    module TextLeveling
      class Enable < Subcommand
        NAME = :enable
        DESCRIPTION = 'Enable text leveling'

        private

        def command_action
          preferences_repository.set_text_leveling(enabled: true)

          transmitter.response(event:,
                               text:
                               t('commands.administrator.text_leveling.enable.text_leveling_successfully_enabled'))
        end

        def preferences_repository
          server_service.preferences_repository
        end
      end
    end
  end
end
