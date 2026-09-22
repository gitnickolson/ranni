# frozen_string_literal: true

module Commands
  module Administrator
    module CustomVoiceChannels
      class Disable < Subcommand
        NAME = :disable
        DESCRIPTION = 'Disable custom voice channel creation'

        private

        def command_action
          preferences_repository.set_custom_voice_channels_creation(enabled: false)
          transmitter.response(
            event:,
            text: t('commands.administrator.custom_voice_channels.disable.custom_voice_channels_successfully_disabled')
          )
        end

        def preferences_repository
          server_service.preferences_repository
        end
      end
    end
  end
end
