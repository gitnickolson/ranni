# frozen_string_literal: true

module Commands
  module Administrator
    module VoiceLeveling
      class Disable < Subcommand
        NAME = :disable
        DESCRIPTION = 'Disable voice leveling'

        private

        def command_action
          preferences_repository.update_voice_leveling_status(turned_on: false)
          transmitter.response(event:,
                               text:
                               t('commands.administrator.voice_leveling.disable.voice_leveling_successfully_disabled'))
        end

        def preferences_repository
          @preferences_repository ||= Repositories::PreferencesRepository.new(server_id: server.id)
        end
      end
    end
  end
end
