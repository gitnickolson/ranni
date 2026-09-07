# frozen_string_literal: true

module Commands
  module Administrator
    module CustomVoiceChannels
      class Enable < Subcommand
        NAME = :enable
        DESCRIPTION = 'Enable custom voice channel creation'

        private

        def command_action
          preferences_repository.update_custom_voice_channel_creation_status(turned_on: true)

          transmitter.response(
            event:,
            text: t('commands.administrator.custom_voice_channels.enable.custom_voice_channels_successfully_enabled')
          )
        end

        def preferences_repository
          @preferences_repository ||= Repositories::PreferencesRepository.new(server_id: server.id)
        end
      end
    end
  end
end
