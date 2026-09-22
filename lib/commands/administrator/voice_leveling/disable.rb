# frozen_string_literal: true

module Commands
  module Administrator
    module VoiceLeveling
      class Disable < Subcommand
        NAME = :disable
        DESCRIPTION = 'Disable voice leveling'

        private

        def command_action
          preferences_repository.set_voice_leveling(enabled: false)
          transmitter.response(event:,
                               text:
                               t('commands.administrator.voice_leveling.disable.voice_leveling_successfully_disabled'))
        end

        def preferences_repository
          server_service.preferences_repository
        end
      end
    end
  end
end
