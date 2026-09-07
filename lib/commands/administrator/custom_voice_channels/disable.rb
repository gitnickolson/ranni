# frozen_string_literal: true

module Commands
  module Administrator
    module CustomVoiceChannels
      class Disable < Subcommand
        NAME = :disable
        DESCRIPTION = 'Disable custom voice channel creation'

        private

        def command_action
          preferences_repository.update_custom_voice_channel_creation_status(turned_on: false)
          transmitter.response(
            event:,
            text: t('commands.administrator.custom_voice_channels.disable.custom_voice_channels_successfully_disabled')
          )
        end

        def preferences_repository
          @preferences_repository ||= Repositories::PreferencesRepository.new(server_id: server.id)
        end
      end
    end
  end
end
