# frozen_string_literal: true

module Commands
  module Administrator
    module CustomVoiceChannels
      class Enable < Subcommand
        NAME = :enable
        DESCRIPTION = 'Enable custom voice channel creation'

        private

        def command_action
          preferences_repository.set_custom_voice_channels_creation(enabled: true)

          transmitter.response(
            event:,
            text: t('commands.administrator.custom_voice_channels.enable.custom_voice_channels_successfully_enabled')
          )
        end

        def preferences_repository
          server_service.preferences_repository
        end
      end
    end
  end
end
