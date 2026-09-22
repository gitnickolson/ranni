# frozen_string_literal: true

module Commands
  module Administrator
    module VoiceLeveling
      class Enable < Subcommand
        NAME = :enable
        DESCRIPTION = 'Enable voice leveling'

        private

        def command_action
          preferences_repository.set_voice_leveling(enabled: true)
          transmitter.response(event:,
                               text:
                               t('commands.administrator.voice_leveling.enable.voice_leveling_successfully_enabled'))
        end

        def preferences_repository
          server_service.preferences_repository
        end
      end
    end
  end
end
