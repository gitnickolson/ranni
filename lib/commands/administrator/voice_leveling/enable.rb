# frozen_string_literal: true

module Commands
  module Administrator
    module VoiceLeveling
      class Enable < Subcommand
        NAME = :enable
        DESCRIPTION = 'Enable voice leveling'

        private

        def command_action
          preferences_repository.update_voice_leveling_status(turned_on: true)
          transmitter.response(event:,
                               text:
                               t('commands.administrator.voice_leveling.enable.voice_leveling_successfully_enabled'))
        end

        def preferences_repository
          @preferences_repository ||= Repositories::PreferencesRepository.new(server_id: server.id)
        end
      end
    end
  end
end
